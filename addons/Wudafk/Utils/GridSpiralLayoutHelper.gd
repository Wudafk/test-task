# spiral_grid_generator.gd
class_name GridSpiralLayoutHelper

const GRID_SIZE = 30 # Это 30x30
const _CENTER_OFFSET_X = 0#(GRID_SIZE - 1) / 2.0
const _CENTER_OFFSET_Y = 0#(GRID_SIZE - 1) / 2.0

# @param id: Уникальный ID позиции, начиная с 1.
# @param cell_size: Размер каждой ячейки в мировых координатах (например, 10 для 10x10 юнитов)
static func GetPositionForIdStatic(id: int, cell_size: float = 10.0) -> Vector3:
	if id < 1:
		push_error("ID must be 1 or greater for spiral position generation.")
		return Vector3.ZERO

	var spiral_x = 0
	var spiral_y = 0
	var spiral_dx = 1 # Изменение X: 1=вправо, -1=влево, 0=нет
	var spiral_dy = 0 # Изменение Y: 1=вниз, -1=вверх, 0=нет
	var spiral_segment_length = 1
	var spiral_segment_passed = 0
	var spiral_state = 0 # 0: вправо, 1: вниз, 2: влево, 3: вверх

	# Если id == 1, то это центр, никаких итераций не требуется
	if id == 1:
		var final_x = (_CENTER_OFFSET_X) * cell_size
		var final_z = (_CENTER_OFFSET_Y) * cell_size
		return Vector3(final_x, 0, final_z)

	# Прокручиваем спираль до нужного ID, начиная со 2-й позиции
	for i in range(2, id + 1):
		spiral_x += spiral_dx
		spiral_y += spiral_dy
		spiral_segment_passed += 1

		if spiral_segment_passed == spiral_segment_length:
			spiral_segment_passed = 0
			spiral_state = (spiral_state + 1) % 4

			if spiral_state == 0: # Смена с вверх на вправо
				spiral_dx = 1
				spiral_dy = 0
				spiral_segment_length += 1 # Увеличиваем длину сегмента
			elif spiral_state == 1: # Смена с вправо на вниз
				spiral_dx = 0
				spiral_dy = 1
			elif spiral_state == 2: # Смена с вниз на влево
				spiral_dx = -1
				spiral_dy = 0
				spiral_segment_length += 1 # Увеличиваем длину сегмента
			elif spiral_state == 3: # Смена с влево на вверх
				spiral_dx = 0
				spiral_dy = -1
	
	# Смещаем координаты так, чтобы 0,0 был в центре сетки
	var final_x = (spiral_x + _CENTER_OFFSET_X) * cell_size
	var final_z = (spiral_y + _CENTER_OFFSET_Y) * cell_size
	
	return Vector3(final_x, 0, final_z)
