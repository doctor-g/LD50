all: windows linux

clean:
	rm -rf build

windows:
	mkdir -p build/linux
	godot -v --export "Linux/X11" ../build/linux/bomp.x86_64 project/project.godot

linux:
	mkdir -p build/windows
	godot -v --export "Windows Desktop" ../build/windows/bomp.exe project/project.godot
