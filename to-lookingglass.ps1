param (
    [Parameter(Mandatory=$true)]
    [string]$video,
    [int]$fps = 30,
    [int]$crf = 25,

    [Parameter(HelpMessage="Base depth network.")]
    [ValidateSet("midas", "strurturedRL", "LeRes")]
    [string]$network = "LeRes",

    [Parameter(HelpMessage="Define max resolution of output.")]
    [double]$resolution = [double]::PositiveInfinity
)

Write-Host "converting $video into a looking glass video..."

$video_name = [io.path]::GetFileNameWithoutExtension($video)
$input = "inputs"
$output = "outputs"

# cleanup dirs
Remove-Item "$input\*.*"
Remove-Item "$output\*.*"

# extract video
ffmpeg -i $video -r $fps/1 "$input/frame_%04d.png"

# run convertion
./convert.ps1 -network $network -resolution $resolution

# create videos
ffmpeg -r $fps -i "$input/frame_%04d.png" -vcodec libx264 -crf $crf -pix_fmt yuv420p "$output/$video_name-color.mp4"
ffmpeg -r $fps -i "$output/frame_%04d.png" -vcodec libx264 -crf $crf -pix_fmt yuv420p "$output/$video_name-depth.mp4"

ffmpeg -i "$output/$video_name-color.mp4" -i "$output/$video_name-depth.mp4" -filter_complex hstack "lg-$video_name.mp4"

Write-Host "done!"