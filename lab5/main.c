#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "utils.h"
#include "operations.h"

int main(int argc, char *argv[]) {
    Uint32 flags;
    int depth, done;
    SDL_Surface *screen, *image, *imageCopy;
    SDL_Event event;

    if (!argv[1]) {
        fprintf(stderr, "Usage: %s <image_file>\n", argv[0]);
        return(1);
    }

    if (SDL_Init(SDL_INIT_VIDEO) < 0) {
        fprintf(stderr, "Couldn't initialize SDL: %s\n", SDL_GetError());
        return(255);
    }

    flags = SDL_SWSURFACE;
    image = Load_image(argv[1]); 
    imageCopy = Load_image(argv[1]); 

    printf("\nImage params:\n width %d, height %d \n", image->w, image->h);
    printf("BitsPerPixel = %i \n", image->format->BitsPerPixel);
    printf("BytesPerPixel = %i \n", image->format->BytesPerPixel);

    SDL_WM_SetCaption(argv[1], "showimage");

    depth = SDL_VideoModeOK(image->w, image->h, 32, flags);
    if (depth==0) {
        if (image->format->BytesPerPixel > 1) {
            depth=32;
        } else {
            depth=8;
        }
    } else if ((image->format->BytesPerPixel > 1) && (depth == 8)) {
        depth = 32;
    }

    if (depth == 8) {
        flags |= SDL_HWPALETTE;
    }    

    screen = SDL_SetVideoMode(image->w, image->h, depth, flags);
    if (screen==NULL) {
        fprintf(stderr,"Couldn't set %dx%dx%d video mode: %s\n", image->w, image->h, depth, SDL_GetError());
        exit(1);
    }

    printf("Set 640x480 at %d bits-per-pixel mode\n",screen->format->BitsPerPixel);
    if (image->format->palette && screen->format->palette) {
        SDL_SetColors(screen, image->format->palette->colors, 0, image->format->palette->ncolors);
    }

    Paint(image, screen);


    done = 0;
    while (!done) {
        if (SDL_PollEvent(&event)) {
            switch (event.type) {
                case SDL_KEYUP:
                    switch (event.key.keysym.sym) {
                        case SDLK_ESCAPE:
                        case SDLK_q:
                            done = 1;
                            break;

                        // TRANSFORM - ROTATE
                        case SDLK_t:
                            Rotate(screen, image->w, image->h);
                            break;

                        // REFLECT VERTICALLY
                        case SDLK_v:
                            SDL_LockSurface(image);
                            Reflect_vertically(image, imageCopy);
                            SDL_UnlockSurface(image);
                            Paint(image, screen);
                            break;

                        // REFLECT HORIZONTALLY
                        case SDLK_h:
                            SDL_LockSurface(image);
                            Reflect_horizontally(image, imageCopy);
                            SDL_UnlockSurface(image);
                            Paint(image, screen);
                            break;

                        // BLUR 
                        case SDLK_b:
                            SDL_LockSurface(image);
                            Blur(image);
                            SDL_UnlockSurface(image);
                            Paint(image, screen);
                            break;

                        // NEGATIVE
                        case SDLK_n:
                            SDL_LockSurface(image);
                            Negative(image);
                            SDL_UnlockSurface(image);
                            Paint(image, screen);
                            break;

                        // DARKEN
                        case SDLK_d:
                            SDL_LockSurface(image);
                            Darken(image);                 
                            SDL_UnlockSurface(image);
                            Paint(image, screen);
                            break;

                        // LIGHTEN
                        case SDLK_l:
                            SDL_LockSurface(image);
                            Lighten(image);
                            SDL_UnlockSurface(image);
                            Paint(image, screen);
                            break;

                        // GRAYSCALE
                        case SDLK_g:
                            SDL_LockSurface(image);
                            Grayscale(image, imageCopy);                
                            SDL_UnlockSurface(image);
                            Paint(image, screen);
                            break;

                        // RED
                        case SDLK_1:
                            SDL_LockSurface(image);
                            Color(image, imageCopy, 0xFF, 0x00, 0x00);      
                            SDL_UnlockSurface(image);
                            Paint(image, screen);
                            break;

                        // GREEN
                        case SDLK_2:
                            SDL_LockSurface(image);
                            Color(image, imageCopy, 0x00, 0xFF, 0x00);
                            SDL_UnlockSurface(image);
                            Paint(image, screen);
                            break;

                        // BLUE
                        case SDLK_3:
                            SDL_LockSurface(image);
                            Color(image, imageCopy, 0x00, 0x00, 0xFF);                 
                            SDL_UnlockSurface(image);
                            Paint(image, screen);
                            break;

                        // RESET
                        case SDLK_r:
                            image = Load_image(argv[1]);
                            Paint(image, screen);
                            break;

                        default:
                            break;
                    }
                    break;

                case SDL_QUIT:
                    done = 1;
                    break;

                default:
                    break;
            }
        } else {
            SDL_Delay(10);
        }
    }

    SDL_FreeSurface(image); 
    SDL_Quit();

    return 0;
} 
