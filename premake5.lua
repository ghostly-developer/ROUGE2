workspace "ROUGE2"
	architecture "x64"
	startproject "Sandbox"

	configurations{
		"Debug", 
		"Release",
		"Dist"
	}

outputdir = "%{cfg.buildcfg}-%{cfg.system}-%{cfg.architecture}"

IncludeDir = {}
IncludeDir["GLFW"] = "ROUGE2/vendor/GLFW/include"
IncludeDir["Glad"] = "ROUGE2/vendor/Glad/include"
IncludeDir["ImGui"] = "ROUGE2/vendor/imgui"
IncludeDir["glm"] = "ROUGE2/vendor/glm"



include "ROUGE2/vendor/GLFW"
include "ROUGE2/vendor/Glad"
include "ROUGE2/vendor/imgui"



project "ROUGE2"
	location "ROUGE2"
	kind "SharedLib" --.dll
	language "C++"
	staticruntime "off"

	targetdir ("bin/" .. outputdir .. "/%{prj.name}")
	objdir ("bin-int/" .. outputdir .. "/%{prj.name}")

	pchheader "r2pch.h"
	pchsource "ROUGE2/src/r2pch.cpp"

	files{
		"%{prj.name}/src/**.h",
		"%{prj.name}/src/**.cpp",
			"%{prj.name}/vendor/glm/glm/**.hpp",
		"%{prj.name}/vendor/glm/glm/**.inl",
	}

	includedirs{
		"%{prj.name}/src",
		"%{prj.name}/vendor/spdlog/include",
		"%{IncludeDir.GLFW}",
		"%{IncludeDir.Glad}",
		"%{IncludeDir.ImGui}",
		"%{IncludeDir.glm}"

	}

	links{
		"GLFW",
		"Glad",
		"ImGui",
		"opengl32.lib",
		"dwmapi.lib"
	}

	filter "system:windows"
		cppdialect "C++17"
		staticruntime "On"
		systemversion "latest"

		defines{
			"R2_PLATFORM_WINDOWS",
			"R2_BUILD_DLL",
			"GLFW_INCLUDE_NONE"
		}

		postbuildcommands{
			("{COPY} %{cfg.buildtarget.relpath} \"../bin/" .. outputdir .. "/Sandbox/\"")
		}
		
	filter "configurations:Debug"
		defines "R2_DEBUG"
		runtime "Debug"
		symbols "On"

	filter "configurations:Release"
		defines "R2_RELEASE"
		runtime "Release"
		optimize "On"

	filter "configurations:Debug"
		defines "R2_DIST"
		runtime "Release"
		optimize "On"

project "Sandbox"
	location "Sandbox"
	kind "ConsoleApp"

	language "C++"
	staticruntime "off"

	targetdir ("bin/" .. outputdir .. "/%{prj.name}")
	objdir ("bin-int/" .. outputdir .. "/%{prj.name}")

	files{
		"%{prj.name}/src/**.h",
		"%{prj.name}/src/**.cpp",
	}

	includedirs{
		"ROUGE2/vendor/spdlog/include",
		"ROUGE2/src",
		"%{IncludeDir.glm}"
	}

	links{
		"ROUGE2"
	}

	filter "system:windows"
		cppdialect "C++17"
		staticruntime "On"
		systemversion "latest"

		defines{
			"R2_PLATFORM_WINDOWS"
		}


	filter "configurations:Debug"
		defines "R2_DEBUG"
		runtime "Debug"
		symbols "On"

	filter "configurations:Release"
		defines "R2_RELEASE"
		runtime "Release"
		optimize "On"

	filter "configurations:Debug"
		defines "R2_DIST"
		runtime "Release"
		optimize "On"