class_name AttackWindow

enum WindowParams {
    LENGTH,                 # Length in frames (at 60 fps, scaled to the actual framerate during animation)
    NUM_FRAMES,
    DAMAGE,
    START_FRAME,
    VELOCITY_TYPE,          # 0 for setting the velocity to (VELOCITY_X, VELOCITY_Y) on the first frame, 1 for adding to the current velocity
    VELOCITY_X,
    VELOCITY_Y,
}

var params = {
    WindowParams.LENGTH : 1,
    WindowParams.NUM_FRAMES : 1,
    WindowParams.START_FRAME : 0,
    WindowParams.VELOCITY_TYPE: 1,
    WindowParams.VELOCITY_X : 0,
    WindowParams.VELOCITY_Y : 0,
}

func set_param(param : WindowParams, value) -> void:
    params[param] = value

func get_param(param : WindowParams):
    return params[param]
