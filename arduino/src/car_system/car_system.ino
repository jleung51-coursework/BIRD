/*
 *
 * This Arduino sketch receives data through serial communication relating
 * to whether or not the sensor systems are activated, and alerts the user if
 * a user is present and the sensors return the presence of an item.
 *
 */

#include <avr/pgmspace.h>
#include <PCM.h>
#include <SoftwareSerial.h>

const unsigned int pinCapacitive = A0;

// PCM.h automatically defines 11 as the speaker pin
const unsigned int pinSpeaker = 11;
const unsigned int pinTransistorPower = 10;
const unsigned int pinProximityTrigger = 9;
const unsigned int pinProximityEcho = 8;
const unsigned int pinCapacitivePower = 7;

const unsigned int pinPowerLED = 6;
const unsigned int pinEssentialLED = 5;
const unsigned int pinGeneralLED = 4;

const unsigned int thresholdProximity = 35;
const unsigned int thresholdCapacitive = 500;

SoftwareSerial ppad(2, 3);

// States
bool powerOn = true;
bool powerToggled = false;

const unsigned char alertSound[] PROGMEM = {
  125, 127, 153, 122, 86, 141, 177, 103, 77, 160, 177, 85, 84, 175, 164, 73, 98, 185, 148, 66, 116, 190, 131, 64, 133, 191, 111, 68, 149, 186, 93, 79, 163, 179, 77, 92, 171, 162, 90, 95, 192, 139, 68, 120, 191, 123, 63, 139, 187, 105, 69, 157, 179, 91, 78, 173, 168, 78, 94, 184, 154, 69, 112, 189, 137, 66, 129, 191, 119, 67, 146, 187, 100, 75, 162, 178, 86, 84, 176, 164, 74, 98, 184, 147, 67, 116, 190, 128, 65, 134, 188, 111, 68, 151, 182, 94, 77, 167, 171, 83, 90, 178, 158, 72, 106, 187, 142, 67, 122, 189, 124, 67, 140, 186, 105, 72, 157, 178, 90, 82, 172, 166, 78, 96, 181, 151, 69, 112, 188, 134, 66, 129, 189, 116, 69, 147, 184, 101, 76, 162, 175, 87, 87, 176, 163, 76, 101, 183, 147, 68, 117, 189, 129, 67, 135, 188, 112, 70, 152, 181, 95, 79, 168, 170, 82, 92, 178, 155, 72, 108, 184, 140, 68, 124, 187, 123, 69, 140, 185, 106, 73, 157, 177, 90, 84, 170, 165, 79, 96, 180, 151, 71, 112, 187, 134, 67, 130, 187, 115, 70, 147, 182, 99, 77, 162, 173, 87, 88, 174, 161, 75, 102, 184, 145, 70, 119, 187, 127, 69, 137, 186, 110, 73, 153, 178, 95, 82, 166, 168, 83, 93, 177, 155, 74, 108, 184, 139, 70, 125, 186, 121, 71, 142, 184, 104, 75, 159, 175, 90, 86, 170, 164, 79, 98, 180, 148, 73, 114, 185, 132, 70, 131, 184, 117, 72, 147, 180, 100, 79, 161, 171, 87, 89, 173, 158, 78, 104, 180, 144, 71, 120, 185, 127, 70, 136, 184, 110, 74, 153, 177, 95, 82, 166, 167, 84, 94, 176, 154, 74, 109, 183, 138, 71, 125, 185, 122, 71, 142, 182, 106, 77, 157, 174, 91, 87, 169, 163, 80, 100, 178, 147, 74, 115, 183, 132, 71, 131, 183, 116, 73, 147, 179, 100, 81, 161, 169, 87, 91, 172, 157, 78, 105, 181, 143, 72, 120, 184, 126, 72, 137, 182, 110, 75, 152, 176, 96, 84, 165, 166, 84, 95, 176, 153, 76, 110, 181, 137, 72, 126, 183, 121, 73, 142, 180, 105, 79, 156, 172, 92, 89, 168, 161, 82, 101, 177, 147, 75, 115, 181, 132, 73, 131, 181, 116, 75, 147, 177, 101, 82, 161, 168, 88, 92, 172, 156, 79, 106, 179, 142, 74, 121, 181, 126, 74, 137, 179, 110, 78, 152, 172, 97, 87, 164, 163, 85, 98, 174, 150, 77, 112, 180, 136, 74, 127, 181, 120, 75, 142, 178, 105, 81, 156, 170, 93, 90, 168, 159, 82, 103, 176, 145, 77, 117, 180, 130, 75, 132, 180, 115, 77, 147, 175, 101, 84, 161, 167, 89, 94, 171, 155, 80, 107, 178, 141, 75, 122, 181, 125, 74, 137, 179, 110, 79, 151, 173, 97, 86, 164, 163, 86, 98, 174, 150, 78, 112, 179, 135, 75, 127, 180, 120, 75, 142, 177, 106, 81, 156, 170, 93, 90, 167, 159, 83, 102, 175, 145, 78, 117, 179, 130, 76, 131, 178, 115, 79, 146, 173, 102, 85, 159, 164, 90, 95, 170, 153, 82, 108, 176, 139, 77, 123, 178, 125, 77, 137, 176, 111, 81, 151, 170, 98, 88, 163, 161, 87, 100, 172, 149, 80, 113, 177, 135, 77, 128, 178, 120, 78, 143, 175, 105, 83, 156, 168, 93, 92, 167, 157, 84, 104, 174, 144, 78, 118, 178, 129, 77, 133, 178, 115, 79, 147, 173, 101, 86, 160, 164, 90, 96, 170, 152, 82, 109, 175, 139, 78, 123, 177, 124, 78, 138, 175, 110, 83, 151, 168, 97, 91, 162, 159, 88, 101, 170, 146, 82, 114, 175, 133, 79, 129, 175, 119, 80, 143, 172, 105, 86, 156, 165, 94, 94, 166, 155, 84, 106, 174, 142, 79, 120, 177, 128, 78, 135, 176, 113, 81, 149, 171, 100, 88, 161, 161, 89, 99, 170, 150, 82, 112, 176, 136, 78, 126, 177, 122, 79, 140, 173, 109, 84, 153, 167, 96, 93, 163, 157, 87, 103, 172, 145, 80, 117, 175, 131, 78, 131, 176, 117, 81, 145, 171, 104, 87, 157, 164, 93, 96, 166, 153, 85, 108, 173, 140, 79, 122, 176, 126, 79, 136, 174, 112, 83, 150, 169, 99, 90, 161, 160, 89, 101, 170, 147, 82, 114, 175, 133, 80, 129, 175, 120, 81, 142, 171, 107, 87, 154, 164, 95, 95, 164, 155, 87, 107, 171, 142, 82, 119, 174, 129, 80, 133, 173, 115, 83, 146, 169, 103, 90, 157, 161, 93, 99, 166, 151, 85, 110, 172, 138, 81, 123, 174, 125, 81, 136, 173, 112, 84, 149, 167, 99, 91, 161, 159, 90, 101, 169, 148, 83, 114, 174, 135, 80, 127, 175, 121, 81, 141, 172, 107, 86, 154, 165, 96, 95, 164, 155, 87, 106, 171, 143, 82, 119, 174, 129, 81, 132, 173, 116, 83, 145, 169, 104, 89, 156, 162, 94, 98, 165, 151, 86, 110, 171, 139, 82, 123, 174, 125, 82, 136, 172, 112, 85, 149, 167, 100, 92, 160, 158, 91, 102, 167, 147, 85, 114, 172, 135, 82, 127, 172, 122, 84, 140, 170, 109, 88, 152, 163, 98, 96, 162, 154, 89, 106, 169, 143, 84, 118, 173, 130, 82, 131, 173, 117, 84, 144, 168, 105, 90, 155, 161, 95, 99, 164, 151, 88, 110, 170, 139, 84, 123, 172, 126, 83, 135, 171, 113, 86, 147, 166, 102, 93, 158, 158, 92, 102, 166, 147, 86, 114, 171, 134, 83, 127, 172, 122, 83, 140, 170, 109, 88, 152, 164, 98, 96, 161, 154, 90, 106, 168, 143, 84, 118, 172, 130, 83, 131, 172, 117, 85, 144, 168, 105, 91, 155, 160, 95, 100, 164, 150, 88, 111, 169, 138, 84, 123, 171, 126, 84, 136, 170, 113, 87, 147, 165, 103, 94, 157, 157, 93, 103, 165, 146, 87, 115, 170, 134, 84, 127, 171, 121, 85, 140, 168, 109, 90, 151, 161, 99, 98, 161, 152, 91, 109, 167, 141, 86, 121, 169, 128, 85, 133, 169, 116, 88, 145, 165, 105, 93, 155, 158, 96, 102, 163, 148, 89, 113, 168, 136, 86, 125, 170, 124, 86, 137, 168, 112, 89, 149, 163, 101, 96, 158, 155, 93, 106, 165, 144, 87, 117, 169, 132, 85, 129, 170, 120, 86, 141, 167, 108, 91, 152, 161, 98, 98, 161, 152, 91, 109, 167, 141, 86, 121, 170, 129, 85, 133, 169, 116, 88, 144, 165, 105, 94, 155, 158, 96, 102, 162, 148, 90, 113, 168, 137, 86, 124, 169, 125, 86, 136, 168, 113, 90, 147, 162, 103, 97, 157, 154, 94, 106, 164, 144, 89, 117, 168, 132, 86, 129, 169, 120, 87, 140, 166, 109, 92, 151, 160, 99, 99, 160, 151, 92, 109, 166, 140, 87, 120, 169, 129, 87, 132, 168, 117, 89, 144, 163, 106, 95, 154, 156, 97, 103, 161, 147, 91, 113, 166, 136, 88, 124, 167, 125, 88, 136, 166, 114, 91, 146, 161, 104, 97, 155, 154, 96, 106, 163, 144, 90, 116, 167, 133, 87, 128, 168, 122, 88, 139, 165, 110, 92, 150, 160, 100, 99, 159, 151, 93, 109, 165, 141, 88, 120, 169, 129, 86, 132, 168, 117, 88, 144, 164, 106, 94, 154, 158, 96, 102, 162, 148, 90, 113, 168, 137, 86, 124, 169, 125, 86, 136, 167, 113, 90, 147, 162, 102, 97, 157, 154, 94, 106, 164, 145, 89, 116, 168, 133, 87, 128, 169, 121, 87, 139, 166, 110, 91, 150, 160, 100, 99, 159, 152, 93, 109, 165, 141, 88, 120, 168, 130, 86, 131, 168, 118, 89, 143, 164, 107, 94, 153, 157, 98, 102, 161, 148, 91, 113, 166, 137, 88, 124, 168, 125, 88, 136, 166, 114, 91, 147, 162, 103, 97, 156, 154, 95, 106, 163, 144, 89, 117, 168, 132, 87, 129, 168, 120, 88, 141, 165, 109, 93, 151, 159, 99, 100, 160, 150, 92, 110, 166, 140, 88, 121, 169, 128, 86, 133, 168, 116, 89, 145, 164, 105, 94, 155, 157, 95, 103, 163, 147, 89, 114, 168, 136, 86, 126, 170, 123, 86, 138, 167, 112, 90, 149, 162, 101, 97, 158, 153, 93, 107, 165, 143, 88, 118, 168, 131, 86, 130, 168, 119, 88, 142, 165, 108, 93, 152, 159, 98, 100, 161, 150, 91, 110, 167, 139, 87, 122, 169, 127, 86, 134, 168, 115, 89, 146, 164, 104, 95, 156, 156, 95, 104, 163, 146, 89, 114, 167, 135, 87, 126, 169, 123, 87, 138, 166, 111, 91, 149, 161, 101, 98, 158, 153, 93, 107, 165, 142, 88, 118, 168, 131, 87, 130, 168, 119, 88, 142, 165, 107, 93, 153, 158, 98, 101, 161, 149, 91, 111, 166, 138, 87, 123, 168, 126, 87, 135, 167, 115, 90, 146, 163, 104, 96, 155, 155, 96, 104, 162, 145, 90, 115, 167, 134, 87, 127, 168, 122, 88, 138, 166, 111, 92, 149, 160, 102, 99, 158, 152, 94, 108, 164, 142, 89, 119, 167, 130, 88, 130, 167, 119, 89, 142, 164, 108, 94, 151, 157, 99, 102, 159, 149, 93, 111, 165, 138, 89, 122, 167, 127, 88, 133, 165, 116, 91, 144, 161, 106, 97, 153, 154, 98, 105, 160, 145, 92, 115, 164, 134, 90, 126, 165, 123, 90, 138, 163, 112, 94, 148, 158, 103, 101, 156, 150, 96, 110, 162, 140, 91, 120, 165, 129, 90, 131, 165, 118, 92, 142, 161, 108, 97, 151, 154, 100, 105, 158, 146, 94, 114, 163, 136, 90, 125, 165, 125, 90, 135, 164, 115, 93, 145, 159, 105, 99, 154, 152, 97, 108, 160, 143, 92, 117, 164, 132, 90, 128, 164, 121, 91, 139, 162, 111, 95, 148, 157, 102, 102, 156, 149, 96, 111, 162, 139, 91, 121, 165, 129, 90, 132, 164, 118, 92, 142, 161, 108, 97, 152, 154, 99, 105, 159, 146, 93, 114, 163, 135, 90, 125, 165, 125, 90, 135, 163, 114, 93, 145, 159, 105, 99, 154, 152, 98, 107, 160, 143, 93, 117, 164, 132, 91, 128, 164, 122, 91, 139, 162, 111, 95, 148, 157, 102, 102, 156, 149, 95, 111, 162, 139, 91, 121, 165, 129, 90, 131, 165, 118, 92, 142, 161, 108, 96, 151, 155, 100, 103, 159, 147, 94, 113, 164, 137, 90, 123, 165, 126, 90, 134, 164, 115, 93, 145, 160, 106, 98, 153, 153, 98, 106, 160, 144, 93, 116, 164, 134, 90, 127, 165, 123, 91, 137, 163, 112, 94, 147, 158, 103, 101, 156, 150, 96, 109, 162, 141, 91, 119, 165, 130, 90, 130, 165, 119, 91, 141, 162, 109, 96, 151, 156, 100, 103, 158, 148, 94, 112, 163, 138, 91, 123, 165, 127, 90, 134, 164, 116, 93, 144, 160, 106, 98, 153, 153, 99, 106, 159, 144, 93, 116, 164, 134, 90, 126, 165, 123, 91, 137, 163, 113, 95, 147, 157, 104, 101, 155, 150, 97, 109, 161, 141, 92, 119, 164, 131, 91, 130, 164, 120, 92, 140, 161, 110, 96, 149, 156, 102, 103, 157, 148, 95, 112, 162, 138, 91, 122, 164, 127, 91, 133, 163, 117, 93, 143, 159, 107, 99, 152, 152, 99, 107, 159, 144, 94, 116, 163, 134, 91, 127, 164, 123, 92, 137, 162, 113, 95, 147, 157, 104, 101, 155, 150, 97, 110, 160, 140, 93, 120, 163, 130, 91, 130, 164, 119, 93, 141, 161, 109, 97, 150, 155, 101, 104, 157, 146, 95, 113, 162, 136, 92, 124, 164, 126, 92, 134, 162, 116, 94, 144, 158, 106, 100, 152, 151, 99, 108, 159, 142, 94, 117, 162, 133, 92, 128, 163, 122, 93, 138, 161, 112, 96, 147, 156, 104, 103, 155, 148, 97, 111, 160, 139, 93, 121, 163, 129, 92, 131, 163, 119, 94, 141, 159, 110, 98, 150, 154, 102, 105, 156, 146, 96, 114, 161, 136, 93, 124, 163, 126, 92, 134, 162, 116, 95, 143, 157, 108, 101, 150, 151, 102, 109, 155, 142, 99, 118, 156, 133, 99, 126, 155, 125, 102, 133, 152, 119, 105, 139, 147, 114, 111, 143, 142, 111, 116, 145, 136, 109, 121, 146, 131, 109, 127, 146, 125, 110, 132, 144, 121, 112, 136, 141, 117, 116, 139, 137, 115, 120, 141, 133, 114, 124, 141, 129, 114, 128, 140, 125, 115, 131, 139, 123, 117, 134, 137, 120, 119, 135, 134, 119, 122, 137, 132, 118, 124, 138, 129, 117, 127, 137, 126, 118, 130, 137, 124, 119, 132, 135, 122, 121, 134, 133, 120, 123, 135, 131, 120, 125, 136, 129, 119, 127, 136, 127, 119, 129, 135, 125, 120, 131, 134, 123, 121, 133, 133, 121, 123, 134, 131, 120, 125, 135, 129, 120, 127, 135, 127, 120, 129, 134, 126, 121, 130, 133, 124, 122, 131, 132, 123, 123, 132, 131, 122, 124, 133, 130, 121, 126, 134, 128, 121, 128, 134, 126, 122, 129, 133, 125, 122, 131, 132, 124, 124, 132, 131, 123, 125, 132, 129, 122, 127, 133, 128, 122, 128, 133, 126, 122, 130, 132, 125, 123, 131, 132, 123, 124, 132, 130, 122, 125, 133, 129, 122, 127, 133, 127, 122, 129, 133, 126, 122, 130, 132, 124, 123, 131, 132, 123, 124, 132, 130, 122, 125, 133, 129, 122, 126, 133, 128, 122, 128, 133, 126, 122, 129, 133, 125, 123, 131, 132, 123, 124, 132, 130, 122, 125, 133, 129, 122, 127, 133, 127, 122, 129, 132, 126, 123, 130, 132, 124, 123, 131, 131, 123, 124, 132, 130, 123, 126, 133, 129, 122, 127, 133, 127, 122, 129, 133, 126, 123, 130, 132, 124, 124, 131, 131, 123, 125, 132, 129, 122, 126, 133, 128, 122, 128, 133, 127, 122, 129, 132, 125, 123, 130, 132, 124, 124, 131, 130, 123, 125, 132, 129, 123, 127, 132, 128, 123, 128, 132, 126, 123, 130, 132, 125, 124, 131, 130, 124, 125, 131, 129, 123, 126, 132, 128, 123, 127, 132, 127, 123, 129, 131, 126, 124, 130, 131, 125, 124, 131, 130, 124, 125, 131, 129, 123, 127, 132, 128, 123, 128, 132, 126, 123, 129, 132, 125, 124, 130, 131, 124, 124, 131, 130, 123, 125, 132, 129, 123, 127, 132, 128, 123, 128, 132, 126, 123, 129, 132, 125, 124, 131, 131, 124, 124, 132, 130, 123, 126, 133, 128, 122, 128, 133, 127, 122, 129, 132, 125, 123, 131, 132, 124, 124, 132, 130, 123, 125, 132, 129, 123, 127, 132, 127, 123, 128, 132, 126, 123, 129, 131, 125, 124, 131, 131, 124, 125, 132, 129, 123, 126, 132, 128, 123, 128, 132, 127, 123, 129, 131, 125, 124, 130, 131, 125, 124, 131, 130, 124, 125, 132, 129, 123, 127, 132, 127, 123, 128, 132, 126, 123, 130, 132, 125, 124, 131, 131, 124, 125, 132, 130, 123, 126, 132, 129, 122, 127, 133, 127, 123, 128, 132, 126, 123, 130, 132, 125, 124, 131, 131, 124, 125, 132, 130, 123, 126, 132, 128, 123, 127, 133, 127, 123, 129, 132, 125, 123, 130, 132, 124, 124, 131, 131, 123, 125, 132, 129, 123, 126, 132, 128, 123, 128, 132, 127, 123, 129, 132, 125, 123, 130, 131, 124, 124, 132, 130, 123, 125, 132, 129, 122, 127, 133, 128, 122, 128, 133, 126, 123, 129, 132, 125, 123, 131, 131, 124, 124, 131, 130, 123, 126, 132, 129, 123, 127, 132, 127, 123, 128, 132, 126, 123, 129, 131, 125, 124, 131, 131, 124, 125, 131, 130, 123, 126, 132, 128, 123, 127, 132, 127, 123, 128, 132, 126, 124, 129, 131, 125, 124, 130, 130, 124, 125, 131, 129, 124, 126, 131, 128, 123, 127, 132, 127, 123, 128, 131, 126, 124, 129, 131, 125, 125, 130, 130, 125, 125, 131, 129, 124, 126, 131, 128, 124, 127, 131, 127, 124, 128, 131, 126, 124, 129, 131, 125, 125, 130, 130, 124, 126, 131, 129, 123, 127, 132, 128, 123, 128, 132, 127, 123, 129, 132, 125, 124, 130, 131, 124, 125, 131, 130, 123, 126, 132, 129, 123, 127, 132, 127, 123, 128, 132, 126, 123, 130, 131, 125, 124, 130, 131, 124, 125, 131, 130, 123, 126, 132, 129, 123, 127, 132, 127, 123, 129, 132, 126, 123, 130, 131, 125, 124, 131, 130, 124, 125, 131, 129, 123, 127, 132, 128, 123, 128, 132, 127, 123, 129, 131, 125, 124, 130, 131, 124, 125, 131, 130, 123, 126, 132, 128, 123, 127, 132, 127, 123, 129, 132, 126, 123, 130, 132, 124, 124, 131, 131, 124, 125, 132, 129, 123, 126, 132, 128, 123, 127, 132, 127, 123, 129, 132, 126, 123, 130, 132, 124, 124, 131, 131, 124, 125, 132, 129, 123, 126, 132, 128, 122, 128, 133, 127, 123, 129, 132, 125, 123, 130, 131, 124, 124, 131, 130, 123, 125, 132, 129, 123, 127, 133, 128, 122, 128, 133, 126, 123, 130, 132, 125, 124, 131, 131, 123, 125, 132, 130, 122, 126, 133, 128, 122, 128, 133, 126, 123, 129, 132, 125, 123, 131, 131, 124, 125, 131, 130, 123, 126, 132, 129, 123, 127, 132, 127, 123, 128, 132, 126, 123, 130, 131, 125, 124, 131, 131, 124, 125, 131, 129, 123, 126, 132, 128, 123, 128, 132, 127, 123, 129, 131, 126, 124, 130, 131, 125, 125, 131, 130, 124, 126, 131, 129, 124, 127, 131, 128, 124, 128, 131, 126, 124, 129, 131, 125, 125, 130, 130, 125, 125, 131, 129, 124, 126, 131, 128, 124, 127, 131, 127, 124, 128, 130, 126, 125, 129, 130, 125, 126, 130, 129, 125, 126, 130, 128, 125, 127, 130, 127, 125, 128, 130, 127, 125, 128, 130, 126, 125, 129, 129, 126, 126, 130, 129, 125, 127, 130, 128, 125, 127, 130, 127, 125, 128, 130, 127, 125, 129, 129, 126, 126, 129, 129, 126, 126, 130, 128, 125, 127, 130, 127, 125, 128, 130, 127, 125, 128, 129, 126, 126, 129, 129, 126, 126, 130, 128, 125, 127, 130, 128, 125, 128, 130, 127, 125, 128, 130, 126, 126, 129, 129, 126, 126, 130, 129, 125, 127, 130, 128, 125, 127, 130, 127, 125, 128, 130, 127, 126, 129, 129, 126, 126, 129, 129, 126, 126, 130, 128, 125, 127, 130, 128, 125, 128, 130, 127, 125, 128, 130, 126, 126, 129, 129, 126, 126, 129, 128, 125, 127, 129, 128, 125, 128, 130, 127, 125, 128, 129, 127, 126, 129, 129, 126, 126, 129, 128, 126, 127, 129, 128, 126, 127, 129, 128, 126, 128, 129, 127, 126, 128, 129, 127, 126, 129, 128, 126, 127, 129, 128, 126, 127, 129, 128, 126, 128, 129, 127, 126, 128, 129, 127, 126, 128, 129, 127, 127, 129, 128, 126, 127, 129, 128, 126, 127, 129, 128, 126, 128, 129, 127, 126, 128, 129, 127, 126, 128, 129, 127, 126, 129, 128, 126, 127, 129, 128, 126, 127, 129, 128, 126, 127, 129, 127, 126, 128, 129, 127, 126, 128, 128, 127, 127, 128, 128, 127, 127, 129, 128, 127, 127, 128, 127, 127, 128, 128, 127, 127, 128, 128, 127, 127, 128, 128, 127, 127, 128, 128, 127, 128, 128, 127, 127, 128, 128, 127, 127, 128, 128, 127, 127, 128, 128, 127, 128, 128, 127, 127, 128, 128, 127, 127, 128, 128, 127, 127, 128, 128, 127, 127, 128, 128, 127, 127, 128, 128, 127, 127, 128, 128, 127, 128, 128, 128, 127, 128, 128, 127, 127, 128, 128, 127, 127, 128, 128, 127, 127, 128, 128, 127, 127, 128, 128, 127, 127, 128, 128, 127, 128, 128, 127, 127, 128, 128, 128, 127, 128, 127, 128, 128, 127, 127, 128, 128, 127, 127, 128, 128, 127, 128, 128, 127, 127, 128, 128, 127, 127, 128, 128, 127, 127, 128, 128, 127, 127, 128, 128, 127, 127, 128, 128, 127, 127, 128, 128, 127, 127, 128, 128, 127, 127, 128, 127, 127, 127, 128, 127, 127, 128, 128, 127, 127, 128, 128, 127, 127, 128, 128, 127, 127, 128, 128, 127, 128, 128, 128, 127, 127, 128, 127, 128, 127, 128, 128, 128, 128, 127, 127, 128, 128, 127, 128, 128, 128, 127, 128, 128, 128, 127, 128, 128, 127, 127, 128, 128, 127, 127, 128, 128, 127, 127, 128, 128, 127, 128, 128, 127, 127, 128, 128, 127, 127, 128, 128, 127, 127, 128, 128, 127, 128, 128, 127, 127, 128, 128, 127, 127, 128, 128, 127, 127, 128, 128, 127, 127, 128, 128, 127, 127, 128, 128, 126, 127, 129, 127, 127, 128, 129, 127, 127, 128, 128, 127, 127, 128, 128, 127, 127, 128, 128, 127, 127, 128, 128, 126, 127, 128, 128, 126, 128, 129, 127, 126, 128, 128, 127, 127, 128, 128, 127, 127, 128, 128, 127, 127, 128, 128, 126, 128, 129, 127, 126, 128, 129, 127, 127, 128, 128, 127, 127, 128, 128, 127, 127, 128, 128, 127, 127, 128, 128, 127, 128, 128, 127, 127, 128, 128, 127, 127, 128, 128, 127, 127, 128, 128, 127, 127, 128, 128, 127, 127, 129, 128, 126, 128, 129, 127, 126, 128, 129, 127, 127, 128, 128, 127, 127, 128, 128, 127, 127, 129, 128, 126, 127, 129, 128, 126, 128, 129, 127, 126, 128, 129, 127, 127, 128, 128, 127, 127, 128, 128, 127, 127, 129, 128, 126, 127, 129, 127, 126, 128, 128, 127, 127, 128, 128, 127, 127, 128, 128, 127, 127, 128, 128, 127, 127, 128, 128, 127, 128, 128, 127, 127, 128, 128, 127, 127, 128, 128, 127, 127, 128, 128, 127, 127, 128, 128, 127, 128, 128, 127, 127, 128, 128, 127, 127, 128, 128, 127, 127, 128, 128, 127, 127, 128, 127, 127, 128, 128, 127, 127, 128, 128, 127, 128, 128, 127, 127, 128, 128, 127, 127, 128, 128, 127, 127, 128, 128, 127, 127, 128, 128, 127, 127, 128, 128, 127, 128, 128, 127, 127, 128, 128, 127, 127, 128, 128, 127, 127, 128, 128, 127, 127, 128, 128, 127, 128, 128, 127, 127, 128, 128, 127, 127, 128, 128, 127, 127, 128, 128, 127, 127, 128, 128, 127, 127, 128, 128, 127, 128, 128, 127, 127, 128, 128, 127, 127, 128, 128, 127, 127, 128, 128, 127, 127, 128, 128, 127, 127, 128, 127, 127, 128, 128, 128, 127, 127, 128, 128, 127, 128, 128, 127, 128, 128, 128, 127, 127, 129, 128, 126, 127, 128, 128, 127, 127, 128, 128, 127, 128, 128, 127, 127, 128, 128, 127, 127, 128, 128, 127, 127, 128, 128, 127, 127, 128, 128, 127, 127, 128, 128, 127, 127, 128, 128, 128, 127, 127, 128, 127, 128, 128, 127, 127, 128, 128, 127, 126, 127, 128, 128, 127, 127, 128, 128, 128, 127, 127, 128, 128, 127, 127, 127, 127, 127, 128, 128, 127, 127, 127, 128, 127, 127, 127, 128, 128, 127, 127, 128, 128, 128, 127, 127, 128, 128, 127, 127, 128, 127, 127, 128, 128, 128, 127, 128, 128, 127, 127, 128, 128, 126, 127, 128, 128, 126, 127, 129, 128, 126, 126, 129, 129, 127, 127, 128, 128, 127, 127, 128, 128, 127, 128, 128, 127, 127, 128, 127, 127, 128, 128, 127, 127, 128, 128, 127, 127, 128, 128, 127, 127, 128, 128, 127, 127, 128, 127, 127, 127, 128, 127, 127, 128, 128, 127, 126, 128, 129, 127, 126, 127, 129, 127, 127, 128, 128, 127, 127, 128, 128, 127, 127, 128, 128, 126, 127, 129, 129, 126, 127, 128, 128, 126, 127, 129, 128, 127, 127, 128, 128, 127, 128, 128, 127, 127, 129, 128, 127, 128, 128, 128, 127, 127, 128, 128, 127, 127, 128, 127, 127, 128, 129, 127, 126, 128, 128, 126, 127, 128, 127, 127, 129, 129, 127, 127, 128, 128, 127, 127, 128, 128, 127, 127, 128, 128, 127, 127, 128, 128, 127, 128, 128, 127, 126, 128, 128, 128, 127, 128, 128, 128, 128, 128, 128, 127, 127, 128, 128, 128, 128, 128, 127, 127, 128, 127, 128, 126, 127, 128, 127, 127, 127, 128, 127, 128, 128, 128, 127, 126, 129, 127, 128, 126, 130, 123, 124, 175, 129, 40, 139, 230, 96, 14, 174, 238, 59, 23, 209, 219, 31, 49, 234, 189, 11, 82, 250, 155, 1, 119, 255, 118, 1, 156, 251, 83, 12, 190, 235, 50, 32, 220, 209, 23, 61, 242, 178, 7, 95, 253, 142, 1, 132, 254, 106, 5, 167, 245, 71, 19, 201, 226, 41, 42, 227, 198, 18, 72, 245, 166, 5, 107, 254, 129, 0, 144, 251, 93, 8, 179, 240, 59, 26, 211, 217, 32, 52, 234, 188, 12, 83, 250, 154, 0, 120, 255, 116, 2, 157, 249, 82, 13, 190, 232, 49, 34, 219, 208, 24, 62, 240, 177, 7, 96, 253, 141, 0, 132, 253, 104, 5, 169, 243, 69, 20, 200, 223, 40, 43, 227, 197, 17, 74, 245, 163, 6, 109, 252, 129, 3, 144, 250, 93, 10, 180, 238, 59, 28, 210, 215, 32, 54, 234, 186, 13, 86, 249, 152, 3, 122, 253, 115, 4, 158, 246, 79, 16, 191, 230, 49, 37, 219, 205, 25, 64, 240, 175, 8, 98, 252, 138, 2, 135, 251, 102, 8, 170, 242, 69, 22, 201, 223, 40, 45, 227, 195, 19, 77, 244, 161, 5, 112, 252, 125, 4, 148, 249, 90, 13, 182, 234, 58, 31, 210, 212, 32, 56, 234, 184, 13, 88, 248, 149, 4, 124, 251, 114, 6, 159, 245, 79, 17, 192, 228, 48, 38, 220, 203, 24, 67, 240, 171, 8, 101, 250, 136, 4, 137, 249, 100, 10, 171, 238, 68, 25, 202, 219, 39, 49, 227, 191, 19, 79, 242, 159, 8, 113, 249, 124, 6, 148, 246, 89, 15, 183, 232, 57, 33, 211, 210, 32, 59, 233, 180, 14, 91, 246, 146, 6, 126, 249, 111, 9, 161, 241, 78, 21, 193, 224, 48, 42, 219, 199, 26, 71, 237, 168, 11, 104, 247, 134, 7, 138, 247, 100, 13, 172, 236, 67, 28, 202, 216, 40, 52, 226, 188, 21, 82, 240, 157, 10, 114, 247, 123, 8, 149, 244, 88, 17, 183, 229, 57, 36, 211, 207, 32, 62, 232, 178, 15, 93, 244, 145, 8, 127, 247, 110, 10, 162, 240, 77, 23, 193, 222, 48, 44, 219, 198, 26, 72, 238, 167, 12, 105, 246, 132, 8, 140, 245, 99, 14, 173, 234, 67, 30, 203, 214, 40, 54, 226, 187, 20, 84, 241, 155, 10, 117, 246, 121, 10, 151, 242, 87, 19, 184, 227, 57, 38, 211, 205, 33, 64, 232, 176, 17, 95, 243, 143, 10, 129, 245, 109, 13, 163, 237, 76, 25, 193, 220, 48, 46, 218, 195, 27, 74, 236, 165, 14, 107, 244, 131, 10, 141, 243, 98, 16, 173, 232, 67, 32, 202, 212, 41, 56, 225, 185, 22, 85, 239, 154, 12, 118, 244, 120, 12, 152, 239, 87, 22, 183, 225, 57, 40, 210, 203, 34, 66, 230, 174, 18, 96, 241, 142, 12, 130, 243, 108, 15, 163, 234, 76, 28, 193, 218, 49, 48, 218, 193, 28, 76, 235, 163, 15, 108, 243, 130, 12, 142, 241, 97, 19, 174, 229, 66, 34, 202, 209, 41, 58, 224, 183, 23, 88, 238, 151, 14, 120, 242, 118, 14, 153, 237, 86, 24, 184, 223, 57, 42, 210, 201, 34, 68, 229, 172, 19, 99, 240, 140, 13, 132, 241, 107, 17, 164, 233, 75, 30, 194, 215, 49, 51, 217, 191, 28, 78, 233, 161, 16, 110, 241, 128, 14, 143, 239, 96, 21, 175, 227, 66, 36, 202, 207, 41, 60, 224, 181, 24, 89, 237, 150, 15, 122, 241, 117, 16, 154, 235, 85, 26, 184, 221, 57, 44, 210, 198, 35, 70, 229, 170, 20, 100, 239, 138, 15, 133, 239, 106, 19, 165, 231, 75, 32, 194, 213, 48, 54, 217, 188, 29, 81, 233, 158, 18, 113, 239, 126, 16, 145, 236, 94, 23, 176, 224, 65, 39, 203, 205, 41, 63, 223, 178, 24, 92, 236, 148, 16, 124, 239, 115, 18, 156, 233, 84, 28, 185, 218, 56, 47, 210, 196, 35, 73, 228, 168, 21, 103, 237, 136, 16, 135, 237, 104, 21, 166, 228, 74, 35, 194, 210, 49, 56, 216, 186, 30, 83, 231, 157, 19, 114, 237, 125, 18, 146, 234, 94, 26, 176, 222, 65, 42, 202, 202, 42, 65, 222, 176, 26, 94, 234, 146, 18, 125, 237, 114, 20, 157, 231, 83, 31, 186, 216, 56, 50, 210, 193, 35, 75, 227, 165, 23, 105, 236, 135, 18, 136, 235, 103, 23, 167, 226, 74, 37, 195, 208, 49, 58, 216, 184, 31, 85, 230, 155, 20, 116, 236, 124, 19, 147, 233, 93, 27, 177, 221, 65, 44, 202, 200, 42, 67, 222, 174, 27, 96, 233, 144, 20, 127, 235, 113, 22, 158, 229, 82, 33, 186, 213, 56, 52, 210, 191, 36, 77, 226, 163, 24, 107, 234, 133, 20, 138, 233, 102, 26, 168, 223, 73, 40, 195, 206, 49, 61, 216, 182, 32, 87, 229, 153, 22, 118, 234, 122, 22, 148, 230, 92, 30, 177, 218, 65, 47, 202, 198, 43, 70, 220, 172, 28, 98, 231, 142, 22, 128, 233, 112, 24, 158, 226, 83, 35, 186, 211, 57, 54, 208, 189, 38, 79, 224, 162, 26, 108, 232, 132, 23, 138, 231, 102, 28, 168, 221, 74, 42, 194, 204, 50, 63, 214, 180, 33, 89, 227, 152, 24, 119, 232, 121, 24, 149, 228, 92, 32, 177, 216, 65, 49, 202, 196, 44, 72, 220, 170, 30, 99, 230, 141, 24, 129, 231, 111, 26, 159, 224, 82, 38, 186, 209, 57, 56, 208, 187, 38, 81, 223, 160, 27, 110, 231, 131, 24, 140, 229, 101, 30, 169, 219, 73, 44, 194, 202, 50, 65, 214, 178, 34, 91, 226, 150, 25, 120, 231, 120, 26, 150, 226, 91, 35, 178, 213, 65, 51, 202, 193, 44, 74, 219, 168, 31, 101, 228, 139, 25, 131, 229, 109, 28, 160, 222, 81, 40, 187, 207, 57, 59, 208, 185, 39, 84, 223, 158, 28, 112, 229, 129, 26, 141, 227, 99, 32, 170, 217, 73, 46, 195, 199, 50, 67, 214, 176, 35, 93, 225, 148, 27, 122, 229, 119, 27, 151, 224, 90, 36, 178, 211, 65, 53, 201, 191, 45, 76, 218, 166, 32, 103, 227, 138, 27, 132, 228, 109, 30, 161, 220, 81, 42, 187, 205, 57, 61, 207, 183, 40, 85, 222, 156, 29, 113, 228, 127, 27, 142, 225, 99, 34, 170, 215, 72, 48, 194, 197, 50, 69, 213, 173, 35, 95, 224, 146, 28, 124, 227, 117, 29, 153, 222, 89, 39, 179, 209, 64, 55, 201, 189, 45, 78, 217, 164, 32, 105, 226, 136, 28, 134, 226, 107, 32, 162, 218, 80, 44, 187, 202, 57, 63, 207, 180, 40, 88, 221, 154, 30, 115, 226, 126, 29, 144, 224, 97, 36, 171, 213, 72, 51, 194, 195, 51, 72, 212, 171, 37, 97, 223, 144, 30, 125, 226, 116, 31, 153, 220, 88, 41, 179, 207, 64, 58, 201, 187, 46, 80, 216, 162, 34, 107, 224, 134, 30, 135, 224, 106, 34, 163, 216, 80, 47, 187, 200, 57, 65, 207, 178, 41, 90, 219, 152, 32, 117, 224, 124, 31, 145, 221, 97, 38, 171, 210, 72, 53, 194, 192, 51, 74, 211, 169, 38, 99, 221, 142, 32, 127, 224, 115, 33, 154, 218, 88, 43, 179, 204, 64, 60, 200, 184, 46, 83, 215, 160, 35, 109, 222, 133, 32, 136, 222, 105, 37, 163, 213, 80, 49, 187, 197, 58, 68, 206, 176, 42, 92, 218, 150, 34, 118, 222, 123, 33, 146, 219, 96, 41, 172, 208, 72, 55, 194, 190, 52, 76, 210, 167, 39, 101, 220, 141, 33, 128, 221, 114, 36, 155, 215, 87, 45, 179, 202, 65, 62, 200, 182, 47, 84, 214, 158, 37, 110, 221, 131, 34, 137, 220, 104, 39, 164, 211, 79, 51, 187, 195, 58, 70, 205, 174, 43, 93, 217, 149, 35, 120, 221, 122, 35, 147, 217, 95, 43, 172, 206, 72, 58, 193, 188, 53, 78, 209, 165, 40, 103, 218, 139, 35, 129, 219, 113, 38, 156, 213, 87, 48, 180, 200, 65, 64, 199, 180, 48, 86, 213, 156, 38, 112, 219, 130, 36, 139, 217, 103, 41, 164, 208, 79, 54, 187, 193, 59, 72, 204, 172, 45, 95, 215, 147, 37, 121, 219, 121, 37, 147, 215, 95, 45, 172, 203, 72, 60, 193, 186, 54, 80, 208, 163, 42, 104, 216, 138, 37, 130, 217, 112, 40, 156, 211, 87, 50, 179, 197, 66, 67, 198, 178, 50, 88, 211, 154, 40, 113, 217, 129, 38, 139, 215, 103, 43, 164, 206, 79, 56, 186, 191, 60, 74, 203, 170, 46, 97, 213, 145, 39, 122, 216, 120, 40, 148, 212, 95, 48, 172, 201, 72, 62, 192, 183, 55, 82, 206, 161, 44, 106, 214, 136, 39, 131, 215, 111, 42, 157, 208, 87, 53, 179, 195, 66, 69, 197, 176, 51, 90, 210, 153, 42, 115, 215, 127, 40, 140, 213, 102, 46, 164, 204, 79, 58, 186, 188, 60, 76, 202, 168, 47, 99, 212, 144, 41, 124, 215, 118, 42, 149, 210, 94, 50, 172, 198, 73, 64, 191, 181, 56, 84, 205, 159, 45, 108, 213, 135, 41, 133, 213, 110, 44, 157, 206, 87, 55, 179, 192, 67, 71, 196, 173, 52, 92, 208, 151, 43, 116, 213, 126, 42, 141, 211, 102, 48, 165, 201, 79, 61, 185, 186, 61, 79, 201, 165, 49, 101, 210, 142, 43, 125, 212, 117, 44, 150, 208, 93, 52, 172, 196, 73, 67, 191, 179, 56, 86, 205, 157, 46, 109, 211, 133, 43, 134, 211, 109, 46, 158, 204, 86, 57, 179, 190, 67, 73, 196, 171, 53, 94, 207, 149, 45, 118, 211, 125, 44, 142, 209, 101, 50, 165, 199, 79, 63, 185, 184, 62, 81, 200, 164, 50, 103, 209, 141, 44, 126, 211, 116, 46, 150, 205, 93, 54, 172, 194, 73, 69, 190, 177, 57, 88, 203, 156, 48, 111, 209, 132, 45, 135, 209, 108, 49, 158, 201, 86, 60, 179, 188, 68, 76, 195, 169, 54, 96, 205, 147, 47, 119, 209, 124, 46, 143, 207, 101, 52, 165, 197, 80, 65, 184, 182, 63, 82, 198, 162, 51, 104, 207, 140, 46, 127, 208, 116, 48, 150, 203, 94, 57, 172, 192, 74, 71, 189, 175, 59, 90, 201, 154, 50, 112, 207, 131, 47, 135, 206, 108, 51, 158, 199, 86, 62, 178, 186, 69, 78, 194, 167, 56, 98, 203, 146, 49, 120, 207, 123, 48, 143, 204, 101, 55, 165, 195, 80, 67, 183, 180, 64, 85, 197, 160, 53, 105, 205, 138, 49, 128, 206, 115, 51, 151, 201, 93, 59, 171, 189, 75, 73, 188, 173, 60, 92, 200, 153, 52, 113, 205, 130, 49, 136, 204, 108, 53, 158, 197, 87, 64, 177, 184, 70, 79, 192, 166, 57, 99, 202, 145, 51, 121, 205, 122, 50, 144, 202, 101, 57, 165, 193, 81, 69, 183, 178, 65, 86, 196, 159, 55, 107, 203, 137, 50, 129, 204, 115, 52, 151, 199, 93, 61, 171, 188, 75, 75, 188, 171, 61, 93, 199, 151, 53, 115, 204, 129, 51, 137, 203, 107, 55, 158, 195, 87, 66, 177, 182, 70, 81, 191, 164, 58, 101, 201, 144, 52, 122, 204, 122, 52, 144, 200, 100, 59, 165, 191, 81, 71, 182, 176, 66, 88, 195, 157, 56, 109, 202, 136, 52, 130, 202, 114, 55, 152, 197, 93, 63, 171, 185, 76, 77, 187, 169, 62, 96, 197, 149, 55, 116, 202, 128, 53, 138, 200, 106, 58, 159, 192, 87, 69, 177, 179, 71, 84, 190, 162, 60, 103, 199, 142, 54, 124, 201, 121, 55, 145, 198, 100, 61, 165, 188, 82, 74, 181, 173, 67, 91, 193, 155, 58, 110, 200, 134, 54, 131, 200, 114, 57, 151, 195, 94, 66, 170, 183, 77, 79, 186, 168, 63, 97, 196, 148, 56, 117, 201, 127, 55, 139, 199, 105, 60, 159, 190, 88, 72, 174, 175, 76, 88, 183, 157, 70, 107, 186, 138, 70, 126, 183, 122, 75, 141, 176, 108, 84, 152, 166, 98, 95, 160, 154, 93, 107, 164, 142, 90, 119, 164, 131, 92, 130, 162, 121, 96, 139, 156, 113, 102, 145, 149, 107, 109, 149, 142, 105, 117, 151, 134, 104, 124, 150, 127, 106, 131, 148, 122, 109, 136, 144, 117, 113, 139, 140, 115, 118, 141, 135, 113, 123, 142, 130, 113, 127, 141, 126, 115, 131, 140, 123, 117, 134, 137, 120, 119, 136, 134, 119, 122, 137, 131, 118, 125, 137, 128, 119, 128, 136, 126, 120, 130, 135, 124, 121, 131, 133, 123, 123, 132, 131, 122, 125, 133, 129, 122, 127, 133, 128, 122, 128, 133, 126, 123, 129, 132, 125, 124, 130, 131, 125, 125, 131, 129, 124, 126, 131, 128, 124, 127, 131, 128, 124, 128, 130, 127, 125, 128, 130, 126, 126, 129, 129, 126, 126, 129, 129, 126, 127, 129, 128, 126, 127, 129, 128, 126, 128, 129, 127, 126, 128, 129, 127, 126, 128, 129, 127, 127, 128, 128, 127, 127, 128, 128, 127, 127, 128, 128, 127, 128, 128, 127, 127, 128, 128, 127, 127, 128, 128, 127, 127, 128, 128, 127, 127, 128, 128, 127, 127, 128, 128, 127, 127, 128, 128, 127, 127, 128, 128, 127, 127, 128, 127, 127, 127, 128, 128, 127, 127, 128, 128, 127, 127, 128, 128, 127, 128, 128, 127, 127, 128, 128, 127, 127, 128, 128, 127, 127, 128, 128, 127, 127, 128, 128, 127, 127, 128, 128, 127, 127, 128, 127, 127, 128, 128, 127, 127, 128, 128, 127, 127, 128, 128, 127, 127, 128, 128, 127, 127, 128, 128, 127, 127, 128, 128, 127, 127, 128, 128, 127, 128, 128, 127, 127, 128, 128, 127, 127, 128, 128, 127, 127, 128, 128, 127, 127, 128, 127, 127, 128, 128, 127, 127, 128, 128, 127, 127, 128, 128, 127, 127, 128, 128, 127, 127, 128, 128, 127, 127, 128, 128, 127, 128, 128, 127, 127, 128, 128, 127, 127, 128, 128, 127, 127, 128, 128, 127, 127, 128, 128, 127, 127, 128, 128, 127, 127, 128, 128, 127, 128, 128, 127, 127, 128, 128, 127, 127, 128, 128, 127, 127, 128, 128, 127, 127, 128, 127, 127, 128, 128, 127, 127, 128, 128, 127, 127, 128, 128, 127, 127, 128, 128, 127, 127, 128, 128, 127, 128, 128, 127, 127, 128, 128, 127, 127, 128, 128, 127, 127, 128, 128, 127, 127, 128, 128, 127, 127, 128, 128, 127, 128, 128, 127, 127, 128, 128, 127, 127, 128, 128, 127, 127, 128, 128, 127, 127, 128, 127, 127, 127, 128, 127, 127, 128, 128, 127, 127, 128, 128, 127, 127, 128, 128, 127, 127, 128, 128, 127, 127, 128, 127, 127, 128, 128, 127, 127, 128, 128, 127, 127, 128, 128, 127, 127, 128, 128, 127, 127, 128, 128, 127, 127, 128, 127, 127, 128, 128, 127, 127, 128, 128, 127, 127, 128, 128, 127, 127, 128, 128, 127, 127, 128, 128, 127, 127, 128, 128, 127, 128, 128, 127, 127, 128, 128, 127, 127, 128, 128, 127, 127, 128, 128, 127, 127, 128, 128, 127, 128, 128, 127, 127, 128, 128, 127, 127, 128, 128, 127, 127, 128, 128, 127, 127, 128, 128, 127, 127, 128, 128, 127, 128, 128, 127, 127, 128, 128, 127, 127, 128, 128, 127, 127, 128, 128, 127, 127, 128, 128, 127, 127, 128, 127, 127, 128, 128, 127, 127, 128, 128, 127, 127, 128, 128, 127, 127, 128, 128, 127, 127, 128, 128, 127, 127, 128, 127, 127, 128, 128, 127, 127, 128, 128, 127, 127, 128, 128, 127, 127, 128, 128, 127, 127, 128, 128, 127, 128, 128, 127, 127, 128, 128, 127, 127, 128, 128, 127, 127, 128, 128, 127, 127, 128, 128, 127, 127, 128, 127, 127, 128, 128, 127, 127, 128, 128, 127, 127, 128, 128, 127, 127, 128, 128, 127, 127, 128, 128, 127, 128, 128, 128, 127, 128, 128, 127, 127, 128, 128, 127, 127, 128, 128, 127, 127, 128, 128, 127, 127, 128, 128, 127, 127, 128, 128, 127, 128, 128, 127, 127, 128, 128, 127, 127, 128, 128, 127, 127, 128, 128, 127, 127, 128, 128, 127, 127, 128, 128, 127, 128, 128, 127, 127, 128, 128, 127, 127, 128, 128, 127, 127, 128, 128, 127, 127, 128, 128, 127, 128, 128, 127, 127, 128, 128, 127, 127, 128, 128, 127, 127, 128, 128, 127, 127, 128, 128, 127, 127, 128, 127, 127, 128, 128, 127, 127, 128, 128, 127, 127, 128, 128, 127, 127, 128, 128, 127, 127, 128, 128, 127, 128, 128, 128, 127, 128, 128, 127, 127, 128, 128, 127, 127, 128, 128, 127, 127, 128, 128, 127, 127, 128, 128, 127, 128, 128, 128, 127, 128, 128, 127, 127, 128, 128, 127, 127, 128, 128, 127, 127, 128, 128, 127, 128, 128, 127, 127, 127, 128, 127, 127, 128, 128, 127, 127, 128, 128, 127, 127, 128, 128, 127, 127, 128, 128, 127, 128, 128, 127, 127, 128, 128, 127, 127, 128, 128, 127, 127, 128, 128, 127, 127, 128, 128, 127, 127, 128, 128, 127, 127, 128, 128, 127, 128, 128, 127, 127, 128, 128, 127, 127, 128, 128, 127, 127, 128, 128, 127, 127, 128, 128, 127, 127, 128, 128, 127, 128, 128, 127, 127, 128, 128, 127, 127, 128, 128, 127, 127, 128, 128, 127, 127, 128, 127, 127, 127, 128, 128, 127, 128, 128, 127, 127, 128, 128, 127, 127, 128, 128, 127, 127, 128, 128, 127, 128, 128, 128, 127, 128, 128, 127, 127, 128, 128, 127, 127, 128, 128, 127, 127, 128, 128, 127, 127, 128, 128, 127, 127, 128, 128, 127, 127, 128, 128, 127, 128, 128, 127, 127, 128, 128, 127, 127, 128, 128, 127, 127, 128, 128, 127, 127, 128, 128, 127, 127, 128, 128, 127, 128, 128, 128, 127, 127, 128, 127, 127, 128, 128, 127, 127, 128, 128, 127, 127, 128, 128, 127, 127, 128, 127, 127, 127, 128, 128, 127, 128, 128, 128, 127, 128, 128, 127, 127, 128, 128, 127, 127, 128, 128, 127, 127, 128, 128, 127, 127, 128, 128, 127, 128, 128, 127, 127, 127, 128, 127, 127, 128, 128, 127, 127, 128, 128, 127, 127, 128, 128, 127, 127, 128, 128, 127, 128,
};

// This method returns whether the proximity sensor reads within
// the proximity threshold.
//
// Configured for the SRF05 Ultrasonic Sensor:
// http://www.robot-electronics.co.uk/htm/srf05tech.htm
bool ProximityActivated() {
  digitalWrite(pinProximityTrigger, LOW);
  delay(2);
  digitalWrite(pinProximityTrigger, HIGH);
  delay(10);
  digitalWrite(pinProximityTrigger, LOW);

  unsigned long distance = pulseIn(pinProximityEcho, HIGH);

  // Divided by 29 because the speed of sound is
  //   343m/sec = 0.0343cm/μs = [1/29.1] cm/μs
  distance = distance / 2 / 29;

  return distance < thresholdProximity;
}

void setup() {
  ppad.begin(9600);

  pinMode(pinCapacitive, INPUT);

  pinMode(pinProximityTrigger, OUTPUT);
  pinMode(pinProximityEcho, INPUT);

  pinMode(pinTransistorPower, OUTPUT);
  pinMode(pinCapacitivePower, OUTPUT);

  pinMode(pinPowerLED, OUTPUT);
  pinMode(pinEssentialLED, OUTPUT);
  pinMode(pinGeneralLED, OUTPUT);

  digitalWrite(pinProximityTrigger, LOW);

  digitalWrite(pinTransistorPower, HIGH);
  digitalWrite(pinCapacitivePower, HIGH);

  digitalWrite(pinPowerLED, HIGH);
}

void loop() {
  ppad.flush();
  delay(100);

  bool alertSensorEssential = false;
  bool alertSensorGeneral = false;

  digitalWrite(pinEssentialLED, LOW);
  digitalWrite(pinGeneralLED, LOW);

  // Power on/off
  if(!powerOn) {
    digitalWrite(pinPowerLED, LOW);
    delay(3 * 1000);  // 3 seconds in addition to the 3 second delay
    powerOn = true;
  }
  else {
    digitalWrite(pinPowerLED, HIGH);

    if(ppad.available()) {
      String in = ppad.readStringUntil('\n');
      alertSensorEssential = (in.charAt(0) == '1');
      alertSensorGeneral = (in.charAt(1) == '1');
      }
    }
  }

  while(powerOn &&
        ProximityActivated() &&
        (alertSensorEssential || alertSensorGeneral)) {

    startPlayback(alertSound, sizeof(alertSound)); // PCM.h

    digitalWrite(pinEssentialLED, LOW);
    digitalWrite(pinGeneralLED, LOW);
    if(alertSensorEssential) {
      digitalWrite(pinEssentialLED, HIGH);

    }
    if(alertSensorGeneral) {
      digitalWrite(pinGeneralLED, HIGH);
    }

    if(analogRead(pinCapacitive) < thresholdCapacitive) {
      powerOn = false;
      digitalWrite(pinPowerLED, LOW);
      digitalWrite(pinEssentialLED, LOW);
      digitalWrite(pinGeneralLED, LOW);
    }

    delay(.2 * 1000);
  }
}