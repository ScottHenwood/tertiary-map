$distination_str = '-36.852276,174.768977|-36.853031,174.767051|-37.786778,175.318616|-40.387307,175.615180|-41.290433,174.7675547|-43.523600,172.583022|-43.643468,172.467323|-45.864720,170.514437'

$uniNames = 'University of Auckland|AUT|University of Waikato|Massey University|Victoria University of Wellington|University of Canterbury|Lincoln University|University of Otago'

$uniNameArr = $uniNames.Split('|')
$locStrings = $distination_str.Split('|')


$processedItems = New-Object System.Collections.Generic.List[Object]

foreach($i in 0..7) {
    $latLng = $locStrings[$i].Split(',')
    $latLngOb = New-Object -TypeName PSObject –Prop (@{
        'lat'=$latLng[0];
        'lng'=$latLng[1]; 
     })

    $object = New-Object -TypeName PSObject –Prop (@{
        'uniName'=$uniNameArr[$i];
        'latLng'=$latLngOb; 
     })

     $processedItems.Add($object)
}

ConvertTo-Json $processedItems | Out-File -FilePath 'uni.json'

# http://geojson.org/