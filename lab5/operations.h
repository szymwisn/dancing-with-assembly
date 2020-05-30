#ifndef OPERATIONS_H
#define OPERATIONS_H

#include <SDL/SDL.h>
#include <SDL/SDL_image.h>

#include "utils.h"

void Rotate(SDL_Surface *image, SDL_Surface *screen);

void Reflect_horizontally(SDL_Surface *image, SDL_Surface *imageCopy);

void Reflect_vertically(SDL_Surface *image, SDL_Surface *imageCopy);

void Blur(SDL_Surface *image);

void Grayscale(SDL_Surface *image, SDL_Surface *imageCopy);

void Color(SDL_Surface *image, SDL_Surface *imageCopy, Uint8 red, Uint8 green, Uint8 blue);

void Negative(SDL_Surface *image);

void Darken(SDL_Surface *image);

void Lighten(SDL_Surface *image);

#endif
