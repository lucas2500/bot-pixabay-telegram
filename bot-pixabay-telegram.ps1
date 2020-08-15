$headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
$headers.Add("Cookie", "__cfduid=daa313a985128d46e16d6a785ac709be01597014185; anonymous_user_id=1e45c34e-1241-47aa-92ae-32f992bb5dd5")

# Termo a ser consultado
$Term = ""
# API key do PixaBay
$ApiKeyPixaBay = ""
# API key do Telegram
$ApiKeyTelegram = ""
# Chat ID do Telegram
$ChatId = ""

$response = Invoke-RestMethod "https://pixabay.com/api/?key=$ApiKeyPixaBay&q=$Term&image_type=photo&pretty=true&per_page=3" -Method "GET"
# $response | ConvertTo-Json

If ($response.totalHits -as [int] -gt 0) {

    $TotalPage = ($response.totalHits -as [int]) / 200
    $TotalPage = ([math]::Round($TotalPage) + 1)

    write-host("Total de paginas a ser consultada: $TotalPage")

    $ArrayImages = @()

    For ($i = 1; $i -lt $TotalPage + 1; $i++) {

        try {

            write-host("Consultando pagina $i de $TotalPage")

            $response = Invoke-RestMethod "https://pixabay.com/api/?key=17835467-728f51a3bef9f34940d03e5f4&q=$Term&image_type=photo&pretty=true&per_page=200&page=$i" -Method "GET"
            # $response | ConvertTo-Json

            foreach ($images in $response) {
                $ArrayImages += ($images.hits.largeImageURL)
            }

        }
        catch {

            write-host("Interropendo consulta da API...")

            break
        }

    }

    write-host("Total de imagens coletadas: " + $ArrayImages.length)

    $ArrayImages | Sort-Object { Get-Random }

    $position = Get-Random -Minimum 1 -Maximum $ArrayImages.length

    write-host("A imagem a ser enviada esta na posicao: $position")

    $message = "Olá, segue a imagem consultada!!"
    $message += "`n"
    $message += $ArrayImages[$position]

    $response2 = Invoke-RestMethod "https://api.telegram.org/$ApiKeyTelegram/sendMessage?chat_id=$ChatId&text=$message&parse_mode=html" -Method "GET"
    # $response2 | ConvertTo-Json

}

Else {
        
    write-host("Nenhuma imagem foi encontrada para o termo '$Term'")
}