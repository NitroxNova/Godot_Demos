extends Resource
class_name Utils

static func transform3d_to_array(xform:Transform3D):
	var array = []
	array.append(vector3_to_array(xform.basis.x))
	array.append(vector3_to_array(xform.basis.y))
	array.append(vector3_to_array(xform.basis.z))
	array.append(vector3_to_array(xform.origin))
	return array

static func vector3_to_array(vec:Vector3):
	var array = []
	array.append(vec.x)
	array.append(vec.y)
	array.append(vec.z)
	return array
	
static func array_to_transform3d(array:Array):
	var x = array_to_vector3(array[0])
	var y = array_to_vector3(array[1])
	var z = array_to_vector3(array[2])
	var o = array_to_vector3(array[3])
	var xform = Transform3D(x,y,z,o)
	return xform
	
static func array_to_vector3(array:Array):
	var vec = Vector3(array[0],array[1],array[2])
	return vec
	

static func save_json(path:String, data):
	var file = FileAccess.open(path,FileAccess.WRITE)
	file.store_line(JSON.stringify(data))
	
static func load_json(path:String):
	var json_as_text = FileAccess.get_file_as_string(path)
	var data = JSON.parse_string(json_as_text)
	return data
