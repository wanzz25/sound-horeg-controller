-- config.lua | Sound Horeg Controller
return {
    version    = "2.0.0",
    scanRadius = 60,
    audioNames = {
        "cr4400","dr260","nr13004mk3","pa1600w","songpicker",
        "vumtr32","audioperipheral","beyondclarity","beyond clarity",
        "speaker","amplifier","subwoofer","mixer","monitor"
    },
    ownerKeys  = {
        "Owner","PlacedBy","SpawnedBy","OwnedBy","PlayerName","Creator"
    },
    powerAttrs = {
        "PowerState","IsOn","Active","Enabled","Power","On"
    },
    knobAttrs  = {
        "Volume","KnobValue","Gain","Level","Output",
        "Master","Value","Rotation","Angle","Intensity"
    },
}
