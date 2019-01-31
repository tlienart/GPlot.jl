const HIST2D_SCALING = Dict{String, String}(
    "none"  => "count",
    "pdf"   => "pdf",
    "prob"  => "probability",
    )
add_dict_vals!(HIST2D_SCALING)

const AXSCALE = Dict{String, Bool}(
    "log"         => true,
    "logarithmic" => true,
    "lin"         => false,
    "linear"      => false,
    )
