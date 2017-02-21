logger = require "logger-sharelatex"

module.exports =
	startDrain: (io, rate) ->
		# Clear out any old interval
		clearInterval @interval
		if rate == 0
			return

		# Get current list of clients to disconnect
		clients = io.sockets.clients()

		# Set a 1 second interval and disconnect <rate> clients each time
		@interval = setInterval () =>
			if !clients.length
				clearInterval @interval
				return
			doDrain clients, rate
		,1000

	drainClients: (clients, rate) ->

			clientSet = clients.splice(0, rate)

			if !clientSet
				logger.log "All clients have been told to reconnectGracefully"
				return

			for client in clientSet
				logger.log {client_id: client.id}, "Asking client to reconnect gracefully"
				client.emit "reconnectGracefully"
