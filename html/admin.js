$(function() {
    // Store selected player
    let selectedPlayer = null;

    // Set the resource name directly to match the folder name
    let resourceName = 'pd-Glitch';

    // Handle incoming messages
    window.addEventListener('message', function(event) {
        var data = event.data;

        if (data.action === 'openAdmin') {
            // Show the menu
            $('body').fadeIn(500);

            // Populate player list
            populatePlayerList(data.players);

        } else if (data.action === 'closeAdmin') {
            $('body').fadeOut(500);

        } else if (data.action === 'updatePlayers') {
            // Update player list
            populatePlayerList(data.players);

        } else if (data.action === 'showError') {
            // Show error message
            showError(data.message);
        }
    });

    // Populate player list
    function populatePlayerList(players) {
        const playerList = $('#player-list');
        playerList.empty();

        if (players.length === 0) {
            playerList.append('<div class="no-players">No players online</div>');
            return;
        }

        players.forEach(player => {
            const playerItem = $(`
                <div class="player-item" data-id="${player.id}">
                    <div class="player-name">${player.name}</div>
                    <div class="player-id">ID: ${player.id}</div>
                </div>
            `);

            playerList.append(playerItem);
        });

        // Reset selected player
        selectedPlayer = null;

        // Add click event to player items
        $('.player-item').click(function() {
            $('.player-item').removeClass('selected');
            $(this).addClass('selected');
            selectedPlayer = $(this).data('id');
        });
    }

    // Show error message
    function showError(message) {
        // Create error element if it doesn't exist
        if ($('#error-message').length === 0) {
            $('<div id="error-message"></div>').appendTo('.content');
        }

        // Show error message
        $('#error-message')
            .text(message)
            .addClass('shake')
            .css({
                'color': 'var(--red)',
                'text-align': 'center',
                'margin-top': '10px',
                'font-weight': '500'
            })
            .show();

        // Remove shake class after animation completes
        setTimeout(() => {
            $('#error-message').removeClass('shake');
        }, 500);

        // Hide error message after 3 seconds
        setTimeout(() => {
            $('#error-message').fadeOut(500);
        }, 3000);
    }

    // Button click handlers
    $('#teleport-button').click(function() {
        if (!selectedPlayer) {
            showError('No player selected');
            return;
        }

        // Send teleport request
        $.post(`https://${resourceName}/adminTeleportPlayer`, JSON.stringify({
            playerId: selectedPlayer
        }));
    });

    $('#teleport-to-button').click(function() {
        if (!selectedPlayer) {
            showError('No player selected');
            return;
        }

        // Send teleport to request
        $.post(`https://${resourceName}/adminTeleportToPlayer`, JSON.stringify({
            playerId: selectedPlayer
        }));
    });

    $('#refresh-button').click(function() {
        // Send refresh request
        $.post(`https://${resourceName}/adminRefreshPlayers`, JSON.stringify({}));
    });

    $('#close-button').click(function() {
        // Send close request
        $.post(`https://${resourceName}/adminClose`, JSON.stringify({}));
        $('body').fadeOut(500);
    });

    // Close on escape key
    document.onkeyup = function(data) {
        if (data.key === 'Escape') {
            $.post(`https://${resourceName}/adminClose`, JSON.stringify({}));
            $('body').fadeOut(500);
        }
    };
});
