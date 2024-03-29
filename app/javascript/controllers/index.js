// This file is auto-generated by ./bin/rails stimulus:manifest:update
// Run that command whenever you add a new controller or create them with
// ./bin/rails generate stimulus controllerName

import { application } from './application';

import AlertController from './alert_controller';
application.register('alert', AlertController);

import ButtonController from './button_controller';
application.register('button', ButtonController);

import CocoonController from './cocoon_controller';
application.register('cocoon', CocoonController);

import ImageCropperController from './image_cropper_controller';
application.register('image-cropper', ImageCropperController);

import RedirectController from './redirect_controller';
application.register('redirect', RedirectController);

import RemoteModalController from './remote_modal_controller';
application.register('remote-modal', RemoteModalController);

import SeatmapController from './seatmap_controller';
application.register('seatmap', SeatmapController);

import SeatmapMutationsController from './seatmap_mutations_controller';
application.register('seatmap-mutations', SeatmapMutationsController);

import TicketScannerController from './ticket_scanner_controller';
application.register('ticket-scanner', TicketScannerController);

import ToggleablePasswordController from './toggleable_password_controller';
application.register('toggleable-password', ToggleablePasswordController);
