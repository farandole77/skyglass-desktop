# SkyGlass Desk 센서 중계 (선택)
# LibreHardwareMonitor / Open Hardware Monitor 의 웹 서버(기본 http://localhost:8085/data.json)를 브라우저가 직접 못 읽을 때만 사용.
# 이 스크립트가 같은 값을 http://localhost:8086/ 로 다시 내보낸다(브라우저 접근 허용 헤더 포함). 이 PC 안에서만 동작하고 밖으로 나가지 않는다.
# 실행: 우클릭 → PowerShell에서 실행, 또는 Start-Desk.bat 의 RELAY 를 1 로.   종료: 창 닫기.
param([int]$Port = 8086, [string]$Source = 'http://localhost:8085/data.json')
$ErrorActionPreference = 'Stop'
$l = New-Object System.Net.HttpListener
$l.Prefixes.Add("http://localhost:$Port/")
$l.Start()
Write-Host "SkyGlass 센서 중계 실행 중: http://localhost:$Port/  <-  $Source   (종료: 창 닫기)"
while ($l.IsListening) {
  $c = $l.GetContext()
  try {
    $r = Invoke-WebRequest -UseBasicParsing -Uri $Source -TimeoutSec 3
    $bytes = if ($r.Content -is [byte[]]) { $r.Content } else { [Text.Encoding]::UTF8.GetBytes([string]$r.Content) }
    $c.Response.StatusCode = 200
  } catch {
    $bytes = [Text.Encoding]::UTF8.GetBytes('{"error":"source unreachable"}')
    $c.Response.StatusCode = 502
  }
  $c.Response.Headers.Add('Access-Control-Allow-Origin', '*')
  $c.Response.Headers.Add('Access-Control-Allow-Private-Network', 'true')
  $c.Response.Headers.Add('Cache-Control', 'no-store')
  $c.Response.ContentType = 'application/json; charset=utf-8'
  $c.Response.OutputStream.Write($bytes, 0, $bytes.Length)
  $c.Response.Close()
}
