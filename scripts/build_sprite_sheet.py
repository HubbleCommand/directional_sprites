from PIL import Image

# false horizontal, true vertical, follow same convention as directional_sprites package
# https://www.executeprogram.com/courses/python-for-programmers/lessons/variadic-function-calls
def build_sprite_sheet(size_x: int, size_y: int, center: bool, direction: bool, dst: str, *frames: str):
	count = len(frames)

	width = size_x if not direction else size_x * count
	height = size_y if direction else size_y * count

	result = Image.new(mode="RGBA", size=(width, height))

	for index, frame_path in enumerate(frames):
		frame = Image.open(frame_path).convert("RGBA")
		x = 0 if not direction else size_x * index
		y = 0 if direction else size_y * index

		if center:
			frame_w, frame_h = frame.size
			if frame_w < size_x:
				x += int((size_x - frame_w) / 2)
			if frame_h < size_y:
				y += int((size_y - frame_h) / 2)

		Image.Image.paste(result, frame, (x, y))

	result.show()
	result.save(dst)


frames = [
	"./Taxi/taxi_S.png",
	"./Taxi/taxi_SE.png",
	"./Taxi/taxi_E.png",
	"./Taxi/taxi_NE.png",
	"./Taxi/taxi_N.png",
	"./Taxi/taxi_NW.png",
	"./Taxi/taxi_W.png",
	"./Taxi/taxi_SW.png",
]
build_sprite_sheet(32, 32, True, True, "output.png", *frames)


def invert_sprite_sheet():
	pass
