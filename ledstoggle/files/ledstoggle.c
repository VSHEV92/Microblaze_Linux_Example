#include<gpiod.h>
#include<unistd.h>

#define LED_NUMB 8 

int main(){

	const char* chip_path = "/dev/gpiochip0";
	struct gpiod_chip* chip;
	struct gpiod_line* pin[LED_NUMB];
	
	// open chip 2
	chip = gpiod_chip_open(chip_path);
	
	//  get lines
	for (int i = 0; i < LED_NUMB; i++){
		pin[i] = gpiod_chip_get_line(chip, i);
		gpiod_line_request_output(pin[i], "gpiod_test", 0);
	}
	
	// start Led toggle
	while (1){
		gpiod_line_set_value(pin[0], 1);
		usleep(100000);

		for (int i = 1; i < LED_NUMB; i++){
			gpiod_line_set_value(pin[i-1], 0);
			gpiod_line_set_value(pin[i], 1);
			usleep(100000); 
		}
		gpiod_line_set_value(pin[LED_NUMB-1], 0);
	}

	return 0;
}
