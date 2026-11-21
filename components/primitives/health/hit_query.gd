class_name HitQuery3D extends RefCounted

static func query_box(
    space: PhysicsDirectSpaceState3D,
    query_transform: Transform3D,
    size: Vector3,
    collision_mask: int,
    exclude: Array[RID] = [],
    max_results := 32,
):
    var shape := BoxShape3D.new()
    shape.size = size
    
    var parameters := PhysicsShapeQueryParameters3D.new()
    parameters.shape = shape
    parameters.transform = query_transform
    parameters.collision_mask = collision_mask
    parameters.collide_with_areas = true
    parameters.collide_with_bodies = true
    parameters.exclude = exclude
    
    var hurtboxes: Array[HurtBox] = []
    var seen := {}
    
    for result in space.intersect_shape(parameters, max_results):
        var hurtbox := result.get("collider") as HurtBox
        if hurtbox == null: continue
        
        var id := hurtbox.get_instance_id()
        if not seen.has(id):
            seen[id] = true
            hurtboxes.append(hurtbox)
    
    return hurtboxes
