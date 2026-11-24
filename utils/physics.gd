class_name PhysicsUtils extends Node

static func query_box_collision(
    space: PhysicsDirectSpaceState3D,
    query_transform: Transform3D,
    size: Vector3,
    collision_mask: int,
    exclude: Array[RID] = [],
    max_results := 32,
) -> Array[Node3D]:
    var shape := BoxShape3D.new()
    shape.size = size
    
    var parameters := PhysicsShapeQueryParameters3D.new()
    parameters.shape = shape
    parameters.transform = query_transform
    parameters.collision_mask = collision_mask
    parameters.collide_with_areas = true
    parameters.collide_with_bodies = true
    parameters.exclude = exclude
    
    var colliders: Array[Node3D] = []
    var seen := {}
    
    for result in space.intersect_shape(parameters, max_results):
        var collider = result.get("collider") as Node3D
        if collider == null: continue
        
        var id := collider.get_instance_id()
        if not seen.has(id):
            seen[id] = true
            colliders.append(collider)
    
    return colliders

static func calculate_ballistic_launch_velocity(
    target: Vector3,
    origin: Vector3,
    time_to_reach: float
):
    var gravity_vector = Utils.get_gravity_vector()
    var displacement = target - origin
    
    return (displacement - 0.5 * gravity_vector * time_to_reach ** 2) / time_to_reach