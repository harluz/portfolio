import consumer from "./consumer";

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
				if (data["id"]) {
					let id = "#" + data["id"];
					$(id).remove();
				} else {
					$("#messages").append(data["message"]);
				}
			},

			destroy: function (id) {
				return this.perform("destroy", {
					id: id,
				});
			},

			speak: function (message) {
				return this.perform("speak", {
					message: message,
				});
			},
		}
	);

	$(document).on("click", ".message_submit", function (event) {
		chatChannel.speak($("[data-behavior~=room_speaker]").val());
		$("[data-behavior~=room_speaker]").val("");
		event.preventDefault();
	});

	$(document).on("click", ".delete-btn", function (event) {
		chatChannel.destroy(event.target.id);
	});
});
