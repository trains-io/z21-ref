#include "server.hpp"
#include <chrono>
#include <cerrno>
#include <cstdio>

namespace {

// Decimal serials starting with 999 identify z21-sim instances (vs physical Z21 hardware).
constexpr uint32_t kSimSerialPrefix = 999u;

int32_t makeSimulatorSerialNumber() {
  auto const epoch_seconds = static_cast<uint32_t>(
    std::chrono::duration_cast<std::chrono::seconds>(
      std::chrono::system_clock::now().time_since_epoch())
      .count());
  return static_cast<int32_t>(kSimSerialPrefix * 1'000'000u + (epoch_seconds % 1'000'000u));
}

}  // namespace

// Implementation of transmit using sendto
void Server::transmit(z21::Socket const& sock,
                      std::span<uint8_t const> datasets) {
  // Transmit UDP datasets using sendto
  if (auto const len{sendto(sock.fd,
                            std::bit_cast<char*>(data(datasets)),
                            size(datasets),
                            0,
                            std::bit_cast<sockaddr*>(&sock.addr),
                            sock.len)};
      len < 0) {
    fprintf(stderr, "sendto failed %s", strerror(errno));
    std::exit(-1);
  }
}

// Enable/disable track power
//
// In real systems this would for example set or clear a GPIO pin.
bool Server::trackPower(bool on) {
  _track_power = on;
  return true;
}

// Send emergency stop
bool Server::stop() { return true; }

// LAN_GET_SERIAL_NUMBER
int32_t Server::serialNumber() const {
  static int32_t const serial{makeSimulatorSerialNumber()};
  return serial;
}

// printf is sufficient
void Server::log(char const* str) { printf("%s\n", str); }
