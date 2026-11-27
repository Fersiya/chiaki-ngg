
if(NOT CHIAKI_USE_SYSTEM_NANOPB)
	##################
	# nanopb
	##################

	add_definitions(-DPB_C99_STATIC_ASSERT) # Fix PB_STATIC_ASSERT on msvc without using C11 for now
	add_subdirectory(nanopb EXCLUDE_FROM_ALL)
	set(NANOPB_GENERATOR_PY "${CMAKE_CURRENT_SOURCE_DIR}/nanopb/generator/nanopb_generator.py" PARENT_SCOPE)
	add_library(nanopb INTERFACE)
	target_link_libraries(nanopb INTERFACE protobuf-nanopb-static)
	target_include_directories(nanopb INTERFACE "${CMAKE_CURRENT_SOURCE_DIR}/nanopb")
	target_compile_definitions(nanopb INTERFACE -DPB_C99_STATIC_ASSERT) # see above
	add_library(Nanopb::nanopb ALIAS nanopb)
endif()

if(NOT CHIAKI_USE_SYSTEM_JERASURE)
	##################
	# gf-complete
	##################

	set(GF_COMPLETE_SOURCE
			gf-complete/src/gf.c
			gf-complete/src/gf_wgen.c
			gf-complete/src/gf_w4.c
			gf-complete/src/gf_w8.c
			gf-complete/src/gf_w16.c
			gf-complete/src/gf_w32.c
			gf-complete/src/gf_w64.c
			gf-complete/src/gf_w128.c
			gf-complete/src/gf_rand.c
			gf-complete/src/gf_general.c
			gf-complete/src/gf_cpu.c)

	# TODO: support NEON

	add_library(gf_complete STATIC ${GF_COMPLETE_SOURCE})
	target_include_directories(gf_complete PUBLIC gf-complete/include)

	# Compile the SSE/SSSE3/PCLMUL code paths of gf-complete on x86_64 (this is what gf-complete's
	# own autotools build does). Without these macros only the slow scalar fallback is built,
	# which makes FEC recovery of lost video packets several times slower.
	# gf-complete still checks the CPU at runtime (gf_cpu.c), so unsupported CPUs use the scalar code.
	if(CMAKE_SYSTEM_PROCESSOR MATCHES "^([xX]86_64|AMD64|amd64|x64)$")
		target_compile_definitions(gf_complete PRIVATE
				INTEL_SSE INTEL_SSE2 INTEL_SSE3 INTEL_SSSE3 INTEL_SSE4 INTEL_SSE4_PCLMUL)
		if(CMAKE_C_COMPILER_ID MATCHES "GNU|Clang")
			# Everything except gf_cpu.c, which has to run safely before the CPU features are known
			set(GF_COMPLETE_SIMD_SOURCE ${GF_COMPLETE_SOURCE})
			list(REMOVE_ITEM GF_COMPLETE_SIMD_SOURCE gf-complete/src/gf_cpu.c)
			set_source_files_properties(${GF_COMPLETE_SIMD_SOURCE} PROPERTIES
					COMPILE_OPTIONS "-msse2;-msse3;-mssse3;-msse4.1;-msse4.2;-mpclmul")
		endif()
	endif()

	##################
	# jerasure
	##################

	set(JERASURE_SOURCE
			jerasure/src/galois.c
			jerasure/src/jerasure.c
			jerasure/src/reed_sol.c
			jerasure/src/cauchy.c
			jerasure/src/liberation.c)

	add_library(jerasure STATIC ${JERASURE_SOURCE})
	target_include_directories(jerasure PUBLIC jerasure/include)
	target_link_libraries(jerasure gf_complete)

	add_library(Jerasure::Jerasure ALIAS jerasure)
endif()

if (NOT CHIAKI_IS_SWITCH) 
	if(NOT CHIAKI_USE_SYSTEM_CURL) 
		##################
		# libcurl (with experimental WebSocket support enabled)
		##################
		set(BUILD_CURL_EXE OFF)
		set(BUILD_SHARED_LIBS OFF)
		set(BUILD_STATIC_LIBS ON)
		set(BUILD_TESTING OFF)
		set(BUILD_EXAMPLES OFF)
		set(CURL_DISABLE_INSTALL ON)
		set(HTTP_ONLY ON)
		set(ENABLE_WEBSOCKETS ON)
		set(CHIAKI_CURL_SOURCE_DIR "${CMAKE_CURRENT_SOURCE_DIR}/curl")
	if(WIN32)
		include("${PROJECT_SOURCE_DIR}/cmake/CurlSchannelAia.cmake")
		set(USE_SSLEAY ON)
		set(CURL_USE_SCHANNEL ON)
	endif()
		find_package(PkgConfig QUIET)
		if (PKG_CONFIG_FOUND)
			pkg_check_modules(PkgLibIdn2 IMPORTED_TARGET GLOBAL libidn2)
		endif ()

		if (PkgLibIdn2_FOUND)
			set(LIBIDN2_INCLUDE_DIR ${PkgLibIdn2_INCLUDE_DIRS} CACHE FILEPATH "libidn2 include path")
			set(LIBIDN2_LIBRARIES ${PkgLibIdn2_LIBRARIES} CACHE STRING "libidn2 libraries")
			set(LIBIDN2_VERSION ${PkgLibIdn2_VERSION})
			add_library(Libidn2::Libidn2 ALIAS PkgConfig::PkgLibIdn2)
			set(Libidn2_FOUND ON)
		endif()
		add_subdirectory("${CHIAKI_CURL_SOURCE_DIR}" "${CMAKE_CURRENT_BINARY_DIR}/curl")
		# Exported library is CURL::libcurl_static
	endif()
endif()

if(CHIAKI_ENABLE_STEAM_SHORTCUT)
	add_subdirectory(cpp-steam-tools)
endif()
