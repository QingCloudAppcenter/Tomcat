import os.path
import xml.dom.minidom

# first check if monitor data is there
if os.path.exists('/tmp/all_data.xml'):
	try:
		dom = xml.dom.minidom.parse('/tmp/all_data.xml')
		root = dom.documentElement
		connectorList = root.getElementsByTagName('connector')
		
		lastpos = len(connectorList) - 1

		for i, connectorItem in enumerate(connectorList):
			connectorName = connectorItem.getAttribute('name')
			threadData = connectorItem.childNodes[0]
			requestData = connectorItem.childNodes[1]
			if i < lastpos:
				print '{\"ajp_connector\":  ' + connectorName + ', \"ajp_currentThreadCount\": ' + threadData.getAttribute('currentThreadCount') + ', \"ajp_currentThreadsBusy\": ' + threadData.getAttribute('currentThreadsBusy') + ', \"ajp_maxTime\": ' + requestData.getAttribute('maxTime') + ', \"ajp_requestCount\": ' + requestData.getAttribute('requestCount') + ","
			else:
				print '\"http_connector\":  ' + connectorName + ', \"http_currentThreadCount\": ' + threadData.getAttribute('currentThreadCount') + ', \"http_currentThreadsBusy\": ' + threadData.getAttribute('currentThreadsBusy') + ', \"http_maxTime\": ' + requestData.getAttribute('maxTime') + ', \"http_requestCount\": ' + requestData.getAttribute('requestCount') + "}"	
	except:
			print  '{\"ajp_connector\":  \"\", \"ajp_currentThreadCount\":  \"\", \"ajp_currentThreadsBusy\":  \"\", \"ajp_maxTime\":  \"\", \"ajp_requestCount\":  \"\", \"http_connector\":  \"\", \"http_currentThreadCount\":  \"\", \"http_currentThreadsBusy\":  \"\", \"http_maxTime\":  \"\", \"http_requestCount\":  \"\"}'
else:
	print  '{\"ajp_connector\":  \"\", \"ajp_currentThreadCount\":  \"\", \"ajp_currentThreadsBusy\":  \"\", \"ajp_maxTime\":  \"\", \"ajp_requestCount\":  \"\", \"http_connector\":  \"\", \"http_currentThreadCount\":  \"\", \"http_currentThreadsBusy\":  \"\", \"http_maxTime\":  \"\", \"http_requestCount\":  \"\"}'