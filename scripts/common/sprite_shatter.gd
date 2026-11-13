class_name SpriteShatter
extends Node2D

const NODE_NAME: StringName = &"SpriteShatter"
const CHUNK_SIZE: int = 4
const MIN_CHUNK_PIXELS: int = 4
const MIN_SPEED: float = 70.0
const MAX_SPEED: float = 160.0
const UPWARD_BOOST: float = 70.0
const GRAVITY: float = 520.0
const DRAG: float = 1.5
const MIN_LIFETIME: float = 0.45
const MAX_LIFETIME: float = 0.8
const BLINK_TIME: float = 0.2
const BLINK_INTERVAL: float = 0.05
const FLASH_DURATION: float = 0.12
const BOUNCE: float = 0.35
const FLOOR_FRICTION: float = 0.6
const FLOOR_PROBE_DISTANCE: float = 96.0
const TERRAIN_MASK: int = 1 << 4
const HIT_POSITION: String = "position"

class Chunk:
	var region: Rect2
	var position: Vector2
	var velocity: Vector2
	var lifetime: float

var texture: Texture2D
var chunks: Array[Chunk] = []
var floor_y: float = INF
var elapsed: float = 0.0

static func spawn(source: AnimatedSprite2D, behind: Node2D) -> SpriteShatter:
	var shatter: SpriteShatter = SpriteShatter.new()
	shatter.name = NODE_NAME
	shatter.material = source.material.duplicate() if source.material else null
	shatter.build_chunks(source)
	behind.add_sibling(shatter, true)
	shatter.global_transform = source.global_transform
	shatter.find_floor()
	if shatter.material:
		VFX.flash(shatter, FLASH_DURATION)
	return shatter

func build_chunks(source: AnimatedSprite2D) -> void:
	var frame_image: Image = get_full_frame_image(source.sprite_frames.get_frame_texture(source.animation, source.frame))
	if source.flip_h:
		frame_image.flip_x()
	if source.flip_v:
		frame_image.flip_y()
	texture = ImageTexture.create_from_image(frame_image)

	var frame_size: Vector2 = Vector2(frame_image.get_size())
	var top_left: Vector2 = source.offset - frame_size / 2.0 if source.centered else source.offset
	var burst_center: Vector2 = top_left + frame_size / 2.0

	var used_rect: Rect2i = frame_image.get_used_rect()
	for chunk_y: int in range(used_rect.position.y, used_rect.end.y, CHUNK_SIZE):
		for chunk_x: int in range(used_rect.position.x, used_rect.end.x, CHUNK_SIZE):
			var region: Rect2i = Rect2i(chunk_x, chunk_y, CHUNK_SIZE, CHUNK_SIZE).intersection(used_rect)
			if count_opaque_pixels(frame_image, region) < MIN_CHUNK_PIXELS:
				continue
			chunks.append(create_chunk(Rect2(region), top_left, burst_center))

func get_full_frame_image(frame_texture: Texture2D) -> Image:
	var frame_image: Image = frame_texture.get_image()
	var atlas: AtlasTexture = frame_texture as AtlasTexture

	if !atlas or atlas.margin == Rect2():
		return frame_image

	frame_image.convert(Image.FORMAT_RGBA8)
	var padded: Image = Image.create_empty(
		frame_texture.get_width(), frame_texture.get_height(), false, Image.FORMAT_RGBA8)
	padded.blit_rect(frame_image, Rect2i(Vector2i.ZERO, frame_image.get_size()), Vector2i(atlas.margin.position))
	return padded

func find_floor() -> void:
	var probe: PhysicsRayQueryParameters2D = PhysicsRayQueryParameters2D.create(
		global_position, global_position + Vector2.DOWN * FLOOR_PROBE_DISTANCE, TERRAIN_MASK)
	var hit: Dictionary = get_world_2d().direct_space_state.intersect_ray(probe)
	if hit:
		var hit_position: Vector2 = hit[HIT_POSITION]
		floor_y = to_local(hit_position).y

func count_opaque_pixels(frame_image: Image, region: Rect2i) -> int:
	var opaque: int = 0
	for y: int in range(region.position.y, region.end.y):
		for x: int in range(region.position.x, region.end.x):
			if frame_image.get_pixel(x, y).a > 0.5:
				opaque += 1
	return opaque

func create_chunk(region: Rect2, top_left: Vector2, burst_center: Vector2) -> Chunk:
	var chunk: Chunk = Chunk.new()
	chunk.region = region
	chunk.position = top_left + region.position
	var outward: Vector2 = (chunk.position + region.size / 2.0 - burst_center).normalized()
	if outward.is_zero_approx():
		outward = Vector2.UP
	chunk.velocity = outward * randf_range(MIN_SPEED, MAX_SPEED) + Vector2.UP * UPWARD_BOOST
	chunk.lifetime = randf_range(MIN_LIFETIME, MAX_LIFETIME)
	return chunk

func _process(delta: float) -> void:
	elapsed += delta
	for chunk: Chunk in chunks:
		chunk.velocity.y += GRAVITY * delta
		chunk.velocity = chunk.velocity.move_toward(Vector2.ZERO, chunk.velocity.length() * DRAG * delta)
		chunk.position += chunk.velocity * delta
		bounce_on_floor(chunk)

	if elapsed >= MAX_LIFETIME:
		queue_free()
		return

	queue_redraw()

func bounce_on_floor(chunk: Chunk) -> void:
	var chunk_bottom: float = chunk.position.y + chunk.region.size.y
	if chunk_bottom < floor_y or chunk.velocity.y <= 0.0:
		return
	chunk.position.y = floor_y - chunk.region.size.y
	chunk.velocity.y *= -BOUNCE
	chunk.velocity.x *= FLOOR_FRICTION

func _draw() -> void:
	for chunk: Chunk in chunks:
		if is_chunk_visible(chunk):
			draw_texture_rect_region(texture, Rect2(chunk.position.round(), chunk.region.size), chunk.region)

func is_chunk_visible(chunk: Chunk) -> bool:
	var time_left: float = chunk.lifetime - elapsed
	if time_left <= 0.0:
		return false
	if time_left > BLINK_TIME:
		return true
	return int(time_left / BLINK_INTERVAL) % 2 == 0
