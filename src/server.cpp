#include <iostream>
#include <fstream>
#include <sstream>
#include <string>
#include <boost/property_tree/ptree.hpp>
#include <boost/property_tree/ini_parser.hpp>
#include <cpprest/http_listener.h>

using namespace web;
using namespace http;
using namespace utility;
using namespace http::experimental::listener;

class HelloWorldHandler {
public:
    void handle_request(http_request request) {
        ucout << "Received request: " << request.to_string() << std::endl;

        json::value response;
        response[U("message")] = json::value::string(U("Hello, World!"));
        request.reply(status_codes::OK, response);
    }
};

int main() {
    // Read the INI file
    boost::property_tree::ptree pt;
    boost::property_tree::ini_parser::read_ini("config.ini", pt);

    // Get the network port
    int port = pt.get<int>("network.port");

    // Configure the REST service
    utility::string_t addr = U("http://localhost:") + utility::conversions::to_string_t(std::to_string(port));
    http_listener listener(addr);

    // Create an instance of the request handler
    HelloWorldHandler handler;

    // Bind the request handler
    listener.support(std::bind(&HelloWorldHandler::handle_request, &handler, std::placeholders::_1));

    // Start the REST service
    try {
        listener
            .open()
            .then([&listener]() { ucout << "Listening on " << listener.uri().to_string() << std::endl; })
            .wait();

        std::string line;
        std::getline(std::cin, line);
    }
    catch (std::exception &e) {
        std::cerr << "Error: " << e.what() << std::endl;
    }

    // Stop the REST service
    listener.close().wait();

    return 0;
}
