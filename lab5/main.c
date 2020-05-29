#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "utils.h"
#include "operations.h"

int main(int argc, char *argv[]) {
    Uint32 flags;
    int depth, done;
    SDL_Surface *screen, *image;
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

    printf("\nImage params:\n width %d, height %d \n", image->w, image->h);
    printf("BitsPerPixel = %i \n", image->format->BitsPerPixel);
    printf("BytesPerPixel = %i \n", image->format->BytesPerPixel);

    SDL_WM_SetCaption(argv[1], "showimage");

    depth = SDL_VideoModeOK(image->w, image->h, 32, flags);
    if (depth==0) {
        if (image->format->BytesPerPixel>1) {
            depth=32;
        } else {
            depth=8;
        }
    } else if ((image->format->BytesPerPixel>1) && (depth==8)) {
        depth = 32;
    }

    if(depth==8) {
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
                        case SDLK_SPACE:
                        case SDLK_f:
                            SDL_LockSurface(image);

                            printf("Start filtering... ");
                            // Reflect(image->pixels, image->w, image->h, size, image->format->BytesPerPixel);
                            printf("Done.\n"); 

                            SDL_UnlockSurface(image);

                            printf("Repainting after filtered... ");
                            Paint(image, screen);
                            printf("Done.\n");

                            break;
                        case SDLK_r:
                            printf("Reloading image... ");
                            image = Load_image(argv[1]);
                            Paint(image,screen);
                            printf("Done.\n");
                            break;
                        case SDLK_s:
                            printf("Saving new image - new.bmp ...");
                            SDL_SaveBMP(image, "new.bmp" );
                            printf("Done.\n");
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
