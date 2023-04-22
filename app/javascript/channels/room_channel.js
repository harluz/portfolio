import consumer from "./consumer";

// $(document).on("turbolinks:load", function () {
$(function () {
	const chatChannel = consumer.subscriptions.create(
		{ channel: "RoomChannel", room: $("#messages").data("room-id") },
		{
			// connected() {
			// Called when the subscription is ready for use on the server
			// },

			// disconnected() {
			// Called when the subscription has been terminated by the server
			// },

			received: function (data) {
				return $("#messages").append(data["message"]);
			},

			speak: function (message) {
				return this.perform("speak", {
					message: message,
				});
			},
		}
	);

	$(document).on("keypress", "[data-behavior~=room_speaker]", function (event) {
		if (event.key === "Enter") {
			chatChannel.speak(event.target.value);
			event.target.value = "";
			event.preventDefault();
		}
	});
});
// });
