FROM tomcat:8.0
ADD ./target/libertyredis.war /usr/local/tomcat/webapps/

# The application uses Compose for Redis-ow as a dependency
# Please provision any dependencies in accordance with the target architecture