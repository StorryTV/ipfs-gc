from http.server import HTTPServer, BaseHTTPRequestHandler


class SimpleHTTPRequestHandler(BaseHTTPRequestHandler):

    def do_GET(self):
        path_info = self.path
        if "/ipfs/" in path_info:
                ipfs_path = path_info.split('/ipfs/')
                self.send_response(307)
                self.send_header ('Location','https://dweb.link/ipfs/'+ipfs_path[1])
                self.end_headers()
        elif "/ipns/" in path_info:
                ipns_path = path_info.split('/ipns/')
                self.send_response(307)
                self.send_header ('Location','https://dweb.link/ipns/'+ipns_path[1])
                self.end_headers()
        else :
                self.send_response(503)
                self.send_header ('Retry-After','3600')
                self.send_header ('Content-Type','text/html')
                self.end_headers()
                self.wfile.write(bytes("<!DOCTYPE html><html><head><meta content=1 http-equiv=X-XSS-Protection><meta charset=UTF-8><meta content=\"width=device-width,initial-scale=1,maximum-scale=1\"name=viewport><title>Maintenance</title><style>body{text-align:center;padding:150px}h1{font-size:50px}body{font:20px Helvetica,sans-serif;color:#333}article{display:block;text-align:left;width:650px;margin:0 auto}a{color:#7100e2;text-decoration:none}a:hover{color:#333;text-decoration:none}</style></head><body><article><h1>We’ll be back soon!</h1><div><p>Sorry for the inconvenience but we’re performing some maintenance at the moment. We’ll be back online shortly!<div id=localipfshtml></div></div></article><script>const localIpfsHtml = '<p>You can access this IPFS CID on your own gateway by going to:</p><p><a href=\"http://localhost:8080/ipfs/' + ipfs_cid + '\" target=\"_self\">http://localhost:8080/ipfs/' + ipfs_cid + '</a></p><p>or</p><p><a href=\"http://127.0.0.1:8080/ipfs/' + ipfs_cid + '\" target=\"_self\">http://127.0.0.1:8080/ipfs/' + ipfs_cid + '</a></p>';window.addEventListener('load', () => {document.getElementById('localipfshtml').outerHTML = localIpfsHtml;});</script></body></html>", "utf8"))

httpd = HTTPServer(('127.0.0.1', 8080), SimpleHTTPRequestHandler)
httpd.serve_forever()
