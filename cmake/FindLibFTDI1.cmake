find_package(PkgConfig)

if (PkgConfig_FOUND)
	pkg_check_modules(PC_LIBFTDI1 QUIET libftdi1)
endif()

if (PC_LIBFTDI1_FOUND)
	add_library(LibFTDI1::ftdi1 INTERFACE IMPORTED)
	set_target_properties(LibFTDI1::ftdi1 PROPERTIES
		INTERFACE_LINK_LIBRARIES "${PC_LIBFTDI1_LDFLAGS}"
		INTERFACE_COMPILE_OPTIONS "${PC_LIBFTDI1_CFLAGS}")

	set(LIBFTDI1_INCLUDE_DIRS "${PC_LIBFTDI1_INCLUDE_DIRS}")
	set(LIBFTDI1_LIBRARIES "${PC_LIBFTDI1_LIBRARIES}")
	set(LIBFTDI1_VERSION_STRING "${PC_LIBFTDI1_VERSION}")
endif()

if (NOT TARGET LibFTDI1::ftdi1)
	find_path(LIBFTDI1_INCLUDE_DIRS ftdi.h PATH_SUFFIXES libftdi1)
	find_library(LIBFTDI1_LIBRARIES ftdi1)

	file(WRITE "${CMAKE_BINARY_DIR}${CMAKE_FILES_DIRECTORY}/CMakeTmp/src.c"
		"#include<ftdi.h>\n#include<stdio.h>\nint main(){printf(\"%s\",ftdi_get_library_version().version_str);return 0;}")

	try_run(_result_var _compile_result_var
		${CMAKE_BINARY_DIR}
		${CMAKE_BINARY_DIR}${CMAKE_FILES_DIRECTORY}/CMakeTmp/src.c
		CMAKE_FLAGS -DINCLUDE_DIRECTORIES:STRING=${LIBFTDI1_INCLUDE_DIRS} -DLINK_LIBRARIES:STRING=${LIBFTDI1_LIBRARIES}
		RUN_OUTPUT_VARIABLE LIBFTDI1_VERSION_STRING)


	add_library(LibFTDI1::ftdi1 INTERFACE IMPORTED)
	set_target_properties(LibFTDI1::ftdi1 PROPERTIES
		INTERFACE_INCLUDE_DIRECTORIES "${LIBFTDI1_INCLUDE_DIRS}"
		INTERFACE_LINK_LIBRARIES "${LIBFTDI1_LIBRARIES}")
endif()

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(LibFTDI1
	REQUIRED_VARS LIBFTDI1_LIBRARIES
	VERSION_VAR LIBFTDI1_VERSION_STRING)

mark_as_advanced(LIBFTDI1_INCLUDE_DIRS LIBFTDI1_LIBRARIES)