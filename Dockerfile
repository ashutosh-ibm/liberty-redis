FROM tomcat:8.0
ADD ./target/libertyredis.war /usr/local/tomcat/webapps/
RUN chmod 777 /usr/local/tomcat/webapps/libertyredis.war
RUN chmod -R 777 /usr/local/tomcat/temp/

# The application uses {u'service_plan': {u'guid': u'4b5d3e38-d5a0-43b2-9c67-f3de368397a0', u'name': u'Standard', u'service': {u'label': u'compose-for-redis', u'guid': u'0e314aea-d2fb-41b9-9eac-bccb2e0f9595', u'version': None, u'provider': None}}, u'last_operation': {u'updated_at': u'2019-07-29T17:13:32Z', u'created_at': u'2019-07-29T17:13:32Z', u'type': u'create', u'state': u'succeeded', u'description': u'This service instance has been successfully created for you.'}, u'name': u'Compose for Redis-ow', u'dashboard_url': u'https://composebroker-dashboard-public.mybluemix.net/?instanceId=8876d54d-225b-431e-9953-b5e8e065186d&X-Bluemix-Authorization-Endpoint=https%3A%2F%2Fmccp.us-south.cf.cloud.ibm.com%2Flogin&X-Bluemix-Authorization-Endpoint-Query=public%3Dtrue', u'shared_from': None, u'bound_app_count': 1, u'shared_to': [], u'guid': u'8876d54d-225b-431e-9953-b5e8e065186d'} as a dependency
# Please provision any dependencies in accordance with the target architecture