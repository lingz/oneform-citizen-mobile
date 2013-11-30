#!/bin/bash
coffee -o www/ -cw www/assets/ &
sass --watch www/assets/css/style.scss:www/css/style.css
