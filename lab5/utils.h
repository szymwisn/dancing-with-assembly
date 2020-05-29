#ifndef UTILS_H
#define UTILS_H

#include <SDL/SDL.h>
#include <SDL/SDL_image.h>

SDL_Surface *Load_image(char *file_name);

void Paint(SDL_Surface *image, SDL_Surface *screen);

Uint32 Get_pixel(SDL_Surface *surface, int x, int y);

void Put_pixel(SDL_Surface *surface, int x, int y, Uint32 pixel);

#endif
