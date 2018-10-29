$processedItems = New-Object System.Collections.Generic.List[Object]

$schools = Import-Csv ".\selected_schools.csv"


#$processedItems = New-Object System.Collections.Generic.List[Object]

foreach($i in 0..($schools.Length-1)) {
    #$latLng = $locStrings[$i].Split(',')
    $latLngOb = New-Object -TypeName PSObject –Prop (@{
        'lat'=$schools[$i].Latitude;
        'lng'=$schools[$i].Longitude; 
     })
     [double[]]$latLngArr =  [double]$latLngOb.lng,  [double]$latLngOb.lat
    $prop = New-Object -TypeName PSObject –Prop (@{
        'name'=$schools[$i].'Provider name';
        'intType'="school";
        'distanceToNearestUni'=$schools[$i].'Distance to nearest uni';
        'size'=$schools[$i].Size;
     })

     $geom = New-Object -TypeName PSObject –Prop (@{
        'type'='Point';
        'coordinates'=$latLngArr; 
     })

     $object = New-Object -TypeName PSObject –Prop (@{
        'type'="Feature";
        'geometry'=$geom; 
        'properties'=$prop;
     })

     #@{
      #  'type'="Feature";
        # 'geometry'=$geom; 
        # 'properties'=$prop;
    #  }


     $processedItems.Add($object)
}

#$distination_str = '-36.852276,174.768977|-36.853031,174.767051|-37.786778,175.318616|-40.387307,175.615180|-41.290433,174.7675547|-43.523600,172.583022|-43.643468,172.467323|-45.864720,170.514437'

#$uniNames = 'University of Auckland|AUT|University of Waikato|Massey University|Victoria University of Wellington|University of Canterbury|Lincoln University|University of Otago'
#$uniNameArr = $uniNames.Split('|')
#$locStrings = $distination_str.Split('|')
$tergeocodes = Get-Content ".\ter.json" | ConvertFrom-Json
foreach($i in 0..($tergeocodes.Length-1)) {
    $tergeocodes[$i]
    [double[]]$latLngArr =  [double]$tergeocodes[$i].lng,  [double]$tergeocodes[$i].lat
    $intType = 'Tertiary';
    if($tergeocodes[$i].number -ge 7000 -and $tergeocodes[$i].number -le 7010 ) {
        $intType = 'University';
    }
    $prop = New-Object -TypeName PSObject –Prop (@{
        'name'=$tergeocodes[$i].name;
        'intType'=$intType;
     })

     $geom = New-Object -TypeName PSObject –Prop (@{
        'type'='Point';
        'coordinates'=$latLngArr; 
     })

     $object = New-Object -TypeName PSObject –Prop (@{
        'type'="Feature";
        'geometry'=$geom; 
        'properties'=$prop;
     })
     $processedItems.Add($object)
}

$featuresCollection = @{
    "type" = "FeatureCollection";
    "features" = $processedItems;
}

ConvertTo-Json $featuresCollection -Depth 10 | Out-File -FilePath 'schGeo.json'