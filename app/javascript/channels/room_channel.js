import consumer from "./consumer";

// $(document).on("turbolinks:load", function () {
const chatChannel = consumer.subscriptions.create("RoomChannel", {
	// connected() {
	// Called when the subscription is ready for use on the server
	// },

	// disconnected() {
	// Called when the subscription has been terminated by the server
	// },

	received: function (data) {
		// return alert(data['message']);
		return $("#messages").append(data["message"]);
	},

	speak: function (message) {
		return this.perform("speak", { message: message });
	},
});

$(document).on("keypress", "[data-behavior~=room_speaker]", function (event) {
	if (event.key === "Enter") {
		chatChannel.speak(event.target.value);
		event.target.value = "";
		event.preventDefault();
	}
});
// });
