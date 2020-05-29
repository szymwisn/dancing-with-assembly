#include "utils.h"

SDL_Surface *Load_image(char *file_name) {
    SDL_Surface *tmp = IMG_Load(file_name);

    if (tmp == NULL) {
        fprintf(stderr, "Couldn't load %s: %s\n", file_name, SDL_GetError());
        exit(0);
    }

    return tmp;
}

void Paint(SDL_Surface *image, SDL_Surface *screen) {
    if(SDL_BlitSurface(image, NULL, screen, NULL) < 0) {
        fprintf(stderr, "BlitSurface eror: %s\n", SDL_GetError());
    }

    SDL_UpdateRect(screen, 0, 0, 0, 0);
};

Uint32 Get_pixel(SDL_Surface *surface, int x, int y) {
    int bytesPerPixel = surface->format->BytesPerPixel;
    Uint8 *p = (Uint8 *)surface->pixels + y *surface->pitch + x *bytesPerPixel;

    switch(bytesPerPixel) {
        case 1:
            return *p;
        case 2:
            return *(Uint16 *)p;
        case 3:
            if(SDL_BYTEORDER == SDL_BIG_ENDIAN)
                return p[0] << 16 | p[1] << 8 | p[2]; //składowe koloru (BE)
            else
                return p[0] | p[1] << 8 | p[2] << 16; //składowe koloru (LE)
        case 4:
            return *(Uint32 *)p;
        default:
            return 0;
    }
} 

void Put_pixel(SDL_Surface *surface, int x, int y, Uint32 pixel) {
    int bytesPerPixel = surface->format->BytesPerPixel;
    Uint8 *p = (Uint8 *)surface->pixels + y * surface->pitch + x * bytesPerPixel;
    
    switch(bytesPerPixel) {
        case 1:
            *p = pixel;
            break;
        case 2:
            *(Uint16 *)p = pixel;
            break;
        case 3:
            if(SDL_BYTEORDER == SDL_BIG_ENDIAN) {
                p[0] = (pixel >> 16) & 0xff; //składowa niebieska (BE)
                p[1] = (pixel >> 8) & 0xff; //składowa zielona
                p[2] = pixel & 0xff; //składowa czerwona (BE)
            } else {
                p[0] = pixel & 0xff; //składowa czerwona (LE)
                p[1] = (pixel >> 8) & 0xff; //składowa zielona
                p[2] = (pixel >> 16) & 0xff; //składowa niebieska (LE)
            }
            break;
        case 4: 
            *(Uint32 *)p = pixel;
            break;
    }
} 
