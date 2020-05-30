#include "operations.h"

void negativeAssembly(unsigned char *in, unsigned char *out, int imgBytes);

void Rotate(SDL_Surface *screen, int width, int height) {
    SDL_Surface *new_screen;
    new_screen = SDL_CreateRGBSurface(0, height, width, 32, 0, 0, 0, 0); 
    Uint32 old_pixel;

    int x, y;
    for (x = 0; x < width; x++) {
        for (y = 0; y < height; y++) {
            old_pixel = Get_pixel(screen, width - x, height - y); 
            Put_pixel(new_screen, y, x, old_pixel); 
        }
    }

    screen = SDL_SetVideoMode(height, width, 32, SDL_SWSURFACE);
    SDL_BlitSurface(new_screen, NULL, screen, NULL);
    SDL_FreeSurface(new_screen);
    SDL_UpdateRect(screen, 0, 0, 0, 0);
} 

void Reflect_horizontally(SDL_Surface *image, SDL_Surface *imageCopy) {
	Uint32 pixel;
    int imgBytes = image->w * image->h * image->format->BytesPerPixel;

	for(int y = 0; y < image->h; y++){
		for(int x = 0; x < image->w; x++){ 
			pixel = Get_pixel(image, image->w - x, y);
			Put_pixel(imageCopy, x, y, pixel);
		}
	}

    memcpy(image->pixels, imageCopy->pixels, imgBytes);
}

void Reflect_vertically(SDL_Surface *image, SDL_Surface *imageCopy) {
	Uint32 pixel;
    int imgBytes = image->w * image->h * image->format->BytesPerPixel;

	for(int y = 0; y < image->h; y++){
		for(int x = 0; x < image->w; x++){ 
            pixel = Get_pixel(image, x, image->h - y);
 			Put_pixel(imageCopy, x, y, pixel);
		}
	}

    memcpy(image->pixels, imageCopy->pixels, imgBytes);
}

void Blur(unsigned char *buf, int width, int height, char bytesPerPixel) {
    int rowsize = ((bytesPerPixel * 8 * width + 31) / 32) * 4;
    int i = 0, j = 0, k = 0, col = 0;
    int *sr = malloc(3 * sizeof(int));

    for (i = 0; i < height; i += 4) {
        for(j = 0; j < rowsize; j+= 12) { 
            for (col = 0; col < 3; col++) {
                sr[col]=0;

                for(k = 0; k < 4; k++) { 
                    sr[col] += (buf[rowsize*i+j+k*3+col] /= 16); 
                    sr[col] += (buf[rowsize*i+j+rowsize+k*3+col] /= 16); 
                    sr[col] += (buf[rowsize*i+j+2*rowsize+k*3+col] /= 16);
                    sr[col] += (buf[rowsize*i+j+3*rowsize+k*3+col] /= 16);
                }

                for(k = 0; k < 4; k++) { 
                    buf[rowsize*i+j+k*3+col] = sr[col]; 
                    buf[rowsize*i+j+rowsize+k*3+col] = sr[col];
                    buf[rowsize*i+j+2*rowsize+k*3+col] = sr[col];
                    buf[rowsize*i+j+3*rowsize+k*3+col] = sr[col];
                }
            }
        }
    }
}


void Grayscale(SDL_Surface *image, SDL_Surface *imageCopy) {
	Uint32 pixel;
    int imgBytes = image->w * image->h * image->format->BytesPerPixel;

	for(int y = 0; y < image->h; y++){
		for(int x = 0; x < image->w; x++){ 
			pixel = Get_pixel(image, x, y);

            Uint8 r = pixel >> 16 & 0xFF;
            Uint8 g = pixel >> 8 & 0xFF;
            Uint8 b = pixel & 0xFF;

            Uint8 colors = 0.212671f * r + 0.715160f * g + 0.072169f * b;
            pixel = (0xFF << 24) | (colors << 16) | (colors << 8) | colors;

			Put_pixel(imageCopy, x, y, pixel);
		}
	}

    memcpy(image->pixels, imageCopy->pixels, imgBytes);
}

void Color(SDL_Surface *image, SDL_Surface *imageCopy, Uint8 red, Uint8 green, Uint8 blue) {
	Uint32 pixel;
    int imgBytes = image->w * image->h * image->format->BytesPerPixel;

	for(int y = 0; y < image->h; y++){
		for(int x = 0; x < image->w; x++){ 
			pixel = Get_pixel(image, x, y);

            Uint8 r = pixel >> 16 & red;
            Uint8 g = pixel >> 8 & green;
            Uint8 b = pixel & blue;

            pixel = (0xFF << 24) | (r << 16) | (g << 8) | b;
			Put_pixel(imageCopy, x, y, pixel);
		}
	}

    memcpy(image->pixels, imageCopy->pixels, imgBytes);
}

void Negative(SDL_Surface *image) {
    int imgBytes = image->w * image->h * image->format->BytesPerPixel;
    unsigned char *result = malloc(imgBytes);

    negativeAssembly(image->pixels, result, imgBytes);
    
    memcpy(image->pixels, result, imgBytes);
} 
