'use strict';

document.addEventListener('DOMContentLoaded', function () {
    const projects_block = document.getElementById('index-projects');

    if (projects_block) {
        const next_button = projects_block.querySelector('button.next');
        const slider = projects_block.querySelector('.biovision-slider');

        if (next_button) {
            let timeout;

            const next_slide = function () {
                next_button.click();
            };

            projects_block.querySelectorAll('button').forEach(function (button) {
                button.addEventListener('click', function () {
                    window.clearTimeout(timeout);

                    timeout = window.setTimeout(next_slide, 5000);
                });
            });

            slider.addEventListener('mouseover', function() {
                window.clearTimeout(timeout);
            });

            slider.addEventListener('mouseout', function() {
                timeout = window.setTimeout(next_slide, 5000);
            });

            timeout = window.setTimeout(next_slide, 5000);
        }
    }
});
