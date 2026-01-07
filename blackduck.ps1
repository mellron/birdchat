[Net.ServicePointManager]::SecurityProtocol = 'tls12'
irm "http://asae-build.us.bank-dns.com/detect10.ps1?$(Get-Random)" | iex
detect `
--blackduck.url=https://usbank.app.blackduck.com `
--blackduck.trust.cert=true `
--detect.project.name=BSDRate `
--detect.project.version.name=BSDRATE.app.001.01.002 `
--detect.code.location.name=BSDRATE.app.001.01.002 `
--detect.source.path='D:\Development_GIT\GitLab\corptreasury\bsdrate\BSDRate\Application\BSDRate\BSDRateUI' `
--detect.bom.aggregate.name=true `
--detect.project.codelocation.unmap=true `
--detect.blackduck.signature.scanner.individual.file.matching=ALL `
--blackduck.proxy.host=web-proxymain.us.bank-dns.com `
--blackduck.proxy.port=3128 `
--blackduck.api.token='M2Y0NzVhZWItNTIyZS00MTI4LWIxODQtYjcxODQ4MmY1YTY4OjNlM2M3OGY4LTc3NzYtNDhhYy05NDdhLTVlY2ZmNGJkMGIwZg=='