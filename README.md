# WebSockets in Lucee Docker
## Introduction
Thanks to [Igal Sapir](https://github.com/isapir) for the Lucee Websockets Extension.

The original example is now a few years old and a few things have changed.

This repo is an adaptation of Igal's original Chat example, updated to work with Lucee 5.3 and Docker. It doesn't go into great detail - it is just enough to provide a working example.

Thanks to [@andreas](https://dev.lucee.org/t/port-8888-not-working-websockets/6551/15) and [@psarin](https://dev.lucee.org/t/port-8888-not-working-websockets/6551/15) for responding to my [Lucee Forum support request](https://dev.lucee.org/t/websocket-getting-started-and-lucee-docker/10841), which enabled me to get this example working. :-)

For background and some explanations: here is the [original video](https://www.youtube.com/watch?v=rvB7PcNylVY) and the chat example wiki: [https://github.com/isapir/lucee-websocket/wiki/Example-Chat](https://github.com/isapir/lucee-websocket/wiki/Example-Chat)

## Lucee and Docker
If you are new to Lucee and / or Docker you might want to check [this tutorial repo](https://github.com/flowt-au/Lucee-docker-how-to).

## To setup this example
Once you have cloned this repo...

1. Make sure Docker Desktop is running (or at least the Docker daemon).
2. From a terminal in this repo:
   `docker-compose up --build`
3. Use the VSCode Docker extension to navigate into the Files of the running `lucee-websocket-chat_lucee:latest` container.
4. Drill down to `/usr/local/tomcat/conf/web.xml` and open that file for editing.
5. Scroll down to the first `<servlet>` block and before (or after) that block copy the following into the file. *It seems it is not that important where it is placed, as long as you dont break the existing XML syntax.*
```
<filter>
  <filter-name>SessionInitializerFilter</filter-name>
  <filter-class>org.apache.catalina.filters.SessionInitializerFilter</filter-class>
</filter>

<filter-mapping>
  <filter-name>SessionInitializerFilter</filter-name>
  <!-- modify url-pattern to match your websocket endpoint !-->
  <url-pattern>/ws/*</url-pattern>
</filter-mapping>
```
6. Restart the Lucee container via Docker Desktop (or CLI). If you rebuild the container (instead of *restarting* it), you will need to repeat steps 3-5.

***Note:** I could not work out how to insert the filter code block above without the manual editing. Perhaps someone can suggest a more automated approach?*

## Run the example
1. Browse to this url in (say) Brave Web Browser: http://localhost:8890/WSexamples/chat/?username=Iambrave
2. Browse to url in some other browser (eg Chrome, Edge, Firefox or Safari): http://localhost:8890/WSexamples/chat/?username=iamchrome
3. For clarity, you can run this on any port you map in the `docker-compose.yml` file. To illustrate, I set port 8890 in this example, but choose your own (including 8888).
4. Repeat for any other browser instances you want. Each needs a different `username` which can be anything you like.

Type a message into the input tag then press Enter, or click "Send", and that message should appear in all the open instances.

Hopefully that gets you going with Lucee WebSockets.

