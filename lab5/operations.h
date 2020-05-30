#ifndef OPERATIONS_H
#define OPERATIONS_H

#include <SDL/SDL.h>
#include <SDL/SDL_image.h>

#include "utils.h"

void Rotate(SDL_Surface *screen, int width, int height);

void Reflect_horizontally(SDL_Surface *image, SDL_Surface *result);

void Reflect_vertically(SDL_Surface *image, SDL_Surface *result);

void Blur(unsigned char *buf, int width, int height, char bytesPerPixel);

void Grayscale(SDL_Surface *image, SDL_Surface *result);

void Color(SDL_Surface *image, SDL_Surface *result, Uint8 red, Uint8 green, Uint8 blue);

void Negative(SDL_Surface *image);

#endif
