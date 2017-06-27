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
			if i < lastpos:
				print '{\"ajp_connector\":  ' + connectorName + ', \"ajp_maxThreads\": ' + threadData.getAttribute('maxThreads') + ', \"ajp_currentThreadCount\": ' + threadData.getAttribute('currentThreadCount') + ', \"ajp_currentThreadsBusy\": ' + threadData.getAttribute('currentThreadsBusy') + ",",
			else:
				print '\"http_connector\":  ' + connectorName + ', \"http_maxThreads\": ' + threadData.getAttribute('maxThreads') + ', \"http_currentThreadCount\": ' + threadData.getAttribute('currentThreadCount') + ', \"http_currentThreadsBusy\": ' + threadData.getAttribute('currentThreadsBusy') + "}"	
	except:
			print  '{\"ajp_connector\":  \"\", \"ajp_maxThreads\":  \"\", \"ajp_currentThreadCount\":  \"\", \"ajp_currentThreadsBusy\":  \"\", \"http_connector\":  \"\", \"http_maxThreads\":  \"\", \"http_currentThreadCount\":  \"\", \"http_currentThreadsBusy\":  \"\"}'
else:
	print  '{\"ajp_connector\":  \"\", \"ajp_maxThreads\":  \"\", \"ajp_currentThreadCount\":  \"\", \"ajp_currentThreadsBusy\":  \"\", \"http_connector\":  \"\", \"http_maxThreads\":  \"\", \"http_currentThreadCount\":  \"\", \"http_currentThreadsBusy\":  \"\"}'