param (
    [Parameter(HelpMessage="Base depth network.")]
    [ValidateSet("midas", "strurturedRL", "LeRes")]
    [string]$network = "LeRes",

    [Parameter(HelpMessage="Colorize depth output.")]
    [switch]$colorize = $false,

    [Parameter(HelpMessage="Color map to apply.")]
    [string]$colormap = "inferno",

    [Parameter(HelpMessage="Define max resolution of output.")]
    [double]$resolution = [double]::PositiveInfinity
)

if ($network -eq "midas") {
    $depth_net = 0
}

if ($network -eq "strurturedRL") {
    $depth_net = 1
}

if ($network -eq "LeRes") {
    $depth_net = 2
}

if ($colorize) {
    $color_arg = "--colorize_results"
}

python run.py --Final --data_dir inputs --output_dir outputs --depthNet $depth_net --max_res $resolution --colormap $colormap $color_arg