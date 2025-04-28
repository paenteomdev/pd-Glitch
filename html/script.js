$(function() {
    // Store last teleport time
    let lastTeleportTime = null;

    // Store report cooldown
    let reportCooldown = 0;

    // Set the resource name directly to match the folder name
    let resourceName = 'pd-Glitch';

    // Store translations
    let translations = {
        unknown: "Unknown",
        meters: "meters",
        never: "Never",
        justNow: "just now",
        secondsAgo: "%s seconds ago",
        minutesAgo: "%s minutes ago",
        hoursAgo: "%s hours ago",
        daysAgo: "%s days ago",
        monthsAgo: "%s months ago",
        yearsAgo: "%s years ago",
        stuck: "Stuck",
        notStuck: "Not Stuck",
        reportButton: "Report Issue",
        reportSent: "Report Sent!",
        closeButton: "Close",
        playerInfo: "Player Information",
        playerId: "Player ID:",
        playerName: "Player Name:",
        currentLocation: "Current Location:",
        stuckStatus: "Stuck Status:",
        groundDistance: "Ground Distance:",
        lastTeleport: "Last Teleport:"
    };

    // Helper function to safely get translation
    function getTranslation(key, defaultValue) {
        return translations[key] || defaultValue || key;
    }

    // Format coordinates nicely
    function formatCoords(coords) {
        if (!coords) return getTranslation('unknown', 'Unknown');
        return `X: ${coords.x.toFixed(2)}, Y: ${coords.y.toFixed(2)}, Z: ${coords.z.toFixed(2)}`;
    }

    // Format distance
    function formatDistance(distance) {
        if (distance === null || distance === undefined) return getTranslation('unknown', 'Unknown');
        return `${distance.toFixed(2)} ${getTranslation('meters', 'meters')}`;
    }

    // Format time ago
    function timeAgo(timestamp) {
        if (!timestamp) return getTranslation('never', 'Never');

        const seconds = Math.floor((new Date() - timestamp) / 1000);

        let interval = Math.floor(seconds / 31536000);
        if (interval > 1) {
            let template = getTranslation('yearsAgo', '%s years ago');
            return template.replace('%s', interval);
        }

        interval = Math.floor(seconds / 2592000);
        if (interval > 1) {
            let template = getTranslation('monthsAgo', '%s months ago');
            return template.replace('%s', interval);
        }

        interval = Math.floor(seconds / 86400);
        if (interval > 1) {
            let template = getTranslation('daysAgo', '%s days ago');
            return template.replace('%s', interval);
        }

        interval = Math.floor(seconds / 3600);
        if (interval > 1) {
            let template = getTranslation('hoursAgo', '%s hours ago');
            return template.replace('%s', interval);
        }

        interval = Math.floor(seconds / 60);
        if (interval > 1) {
            let template = getTranslation('minutesAgo', '%s minutes ago');
            return template.replace('%s', interval);
        }

        if (seconds < 10) return getTranslation('justNow', 'just now');

        let template = getTranslation('secondsAgo', '%s seconds ago');
        return template.replace('%s', Math.floor(seconds));
    }

    // Update player info
    function updatePlayerInfo(data) {
        // Update translations if provided
        if (data.translations) {
            translations = data.translations;
        }

        if (data.playerId !== undefined) {
            $('#player-id').text(data.playerId);
        }

        if (data.playerName) {
            $('#player-name').text(data.playerName);
        }

        if (data.coords) {
            $('#player-coords').text(formatCoords(data.coords));
        }

        if (data.isStuck !== undefined) {
            const stuckStatus = data.isStuck ?
                `<span style="color: #e53935;">${getTranslation('stuck', 'Stuck')}</span>` :
                `<span style="color: #4caf50;">${getTranslation('notStuck', 'Not Stuck')}</span>`;
            $('#stuck-status').html(stuckStatus);
        }

        if (data.groundDistance !== undefined) {
            $('#ground-distance').text(formatDistance(data.groundDistance));
        }

        if (data.lastTeleport) {
            lastTeleportTime = data.lastTeleport;
        }

        // Always update the last teleport time
        $('#last-teleport').text(timeAgo(lastTeleportTime));

        // Update all UI labels with translations
        $('#player-info-title').text(getTranslation('playerInfo', 'Player Information'));
        $('#player-id-label').text(getTranslation('playerId', 'Player ID:'));
        $('#player-name-label').text(getTranslation('playerName', 'Player Name:'));
        $('#current-location-label').text(getTranslation('currentLocation', 'Current Location:'));
        $('#stuck-status-label').text(getTranslation('stuckStatus', 'Stuck Status:'));
        $('#ground-distance-label').text(getTranslation('groundDistance', 'Ground Distance:'));
        $('#last-teleport-label').text(getTranslation('lastTeleport', 'Last Teleport:'));
        $('#report-button-text').text(getTranslation('reportButton', 'Report Issue'));
        $('#close-button-text').text(getTranslation('closeButton', 'Close'));
    }

    // Handle incoming messages
    window.addEventListener('message', function(event) {
        var data = event.data;

        if (data.action === 'open') {
            // Set language attribute for RTL support
            if (data.locale === 'ar') {
                $('html').attr('lang', 'ar');
                $('body').attr('dir', 'rtl');
                $('#arabic-message').show();
                $('#description').hide();
            } else {
                $('html').attr('lang', 'en');
                $('body').attr('dir', 'ltr');
                $('#arabic-message').hide();
                $('#description').show();
            }

            // Set position based on config and language
            let position = data.position;

            // For Arabic, swap left and right positions
            if (data.locale === 'ar') {
                if (position === 'left') {
                    position = 'right';
                } else if (position === 'right') {
                    position = 'left';
                }
            }

            if (position === 'left') {
                $('#unstuck-menu').removeClass('center right').addClass('left');
            } else if (position === 'center') {
                $('#unstuck-menu').removeClass('left right').addClass('center');
            } else {
                $('#unstuck-menu').removeClass('left center').addClass('right');
            }

            // Set text content
            $('#title').text(data.title || 'Unstuck Menu');
            $('#description').text(data.description || 'Use this to teleport out if you are stuck');
            $('.btn-text').first().text(data.button || 'Teleport Out');

            // Update player info
            updatePlayerInfo(data);

            // Show the menu
            $('#unstuck-menu').show();
            $('body').fadeIn(500);

            // Start updating the "time ago" for last teleport
            setInterval(function() {
                $('#last-teleport').text(timeAgo(lastTeleportTime));
            }, 1000);

        } else if (data.action === 'update') {
            // Update player info without reopening the menu
            updatePlayerInfo(data);
        } else if (data.action === 'close') {
            $('#unstuck-menu').hide();
            $('body').fadeOut(500);
        } else if (data.action === 'reportCooldown' || data.action === 'updateReportCooldown') {
            // Update report cooldown
            reportCooldown = data.cooldown;

            // Update button text if on cooldown
            if (reportCooldown > 0) {
                $('#report-button').html(`<span class="btn-text">${reportCooldown}s</span>`);
            } else {
                $('#report-button').html(`<span class="btn-text" id="report-button-text">${getTranslation('reportButton', 'Report Issue')}</span><span class="btn-glow"></span>`);
            }
        } else if (data.action === 'openAdmin') {
            // This is the old action, we'll ignore it
        } else if (data.action === 'openAdminOnly') {
            // Show admin menu only

            // Create admin UI if it doesn't exist
            if ($('#admin-container').length === 0) {
                createAdminUI();
            }

            // Populate reports
            if (data.reports) {
                populateReportsList(data.reports);
            }

            // Show admin UI only
            $('#unstuck-menu').hide(); // Hide the regular menu
            $('#admin-container').show();
            $('body').fadeIn(500);
        } else if (data.action === 'updateAdminMenu') {
            // Update reports
            if (data.reports) {
                populateReportsList(data.reports);
            }
        } else if (data.action === 'updateReports') {
            // Update reports only
            populateReportsList(data.reports);
        }
    });

    // Button click handlers
    $('#unstuck-button').click(function() {
        // Update last teleport time
        lastTeleportTime = new Date();
        $('#last-teleport').text(timeAgo(lastTeleportTime));

        // Send unstuck request
        $.post(`https://${resourceName}/unstuck`, JSON.stringify({}));

        // Hide UI immediately on client side for better responsiveness
        $('body').fadeOut(500);
    });

    $('#report-button').click(function() {
        // Check if on cooldown
        if (reportCooldown > 0) {
            // Show cooldown message
            $(this).html(`<span class="btn-text">${reportCooldown}s</span>`);

            // Shake the button to indicate it's on cooldown
            $(this).addClass('shake');
            setTimeout(() => {
                $(this).removeClass('shake');
            }, 500);

            return;
        }

        // Send report request
        $.post(`https://${resourceName}/report`, JSON.stringify({}));

        // Show feedback
        $(this).html(`<span class="btn-text">${getTranslation('reportSent', 'Report Sent!')}</span>`);
        setTimeout(() => {
            $(this).html(`<span class="btn-text" id="report-button-text">${getTranslation('reportButton', 'Report Issue')}</span><span class="btn-glow"></span>`);
        }, 2000);
    });

    $('#close-button').click(function() {
        $.post(`https://${resourceName}/close`, JSON.stringify({}));
        $('#unstuck-menu').hide();
        $('body').fadeOut(500);
    });

    // Close on escape key
    document.onkeyup = function(data) {
        if (data.key === 'Escape') {
            // Check if admin menu is open
            if ($('#admin-container').is(':visible')) {
                $.post(`https://${resourceName}/adminClose`, JSON.stringify({}));
                $('#admin-container').hide();
                $('body').fadeOut(500);
            } else {
                $.post(`https://${resourceName}/close`, JSON.stringify({}));
                $('#unstuck-menu').hide();
                $('body').fadeOut(500);
            }
        }
    };

    // Create admin UI
    function createAdminUI() {

        // Create admin container
        const adminContainer = $(`
            <div id="admin-container" class="container" style="display: none;">
                <div class="header">
                    <div class="header-bg"></div>
                    <h1>PD-GLITCH Admin Panel</h1>
                </div>
                <div class="content">
                    <div class="player-info">
                        <h2>Player Reports</h2>
                        <div id="reports-list" class="reports-list"></div>
                    </div>
                    <div class="player-info">
                        <h2>Manual Teleport</h2>
                        <div class="manual-teleport">
                            <input type="text" id="player-id-input" placeholder="Enter Player ID" />
                            <button id="teleport-by-id-button">
                                <span class="btn-text">Teleport Player</span>
                                <span class="btn-glow"></span>
                            </button>
                        </div>
                    </div>
                    <div class="buttons">
                        <button id="admin-close-button">
                            <span class="btn-text">Close</span>
                            <span class="btn-glow"></span>
                        </button>
                    </div>
                </div>
                <div class="footer">
                    <p>PD-GLITCH Admin Panel v1.0</p>
                </div>
            </div>
        `);

        // Append to body
        $('body').append(adminContainer);

        // Add event listeners for manual teleport
        $('#teleport-by-id-button').click(function() {
            const playerId = $('#player-id-input').val().trim();
            if (!playerId) {
                showError('Please enter a player ID');
                return;
            }

            $.post(`https://${resourceName}/adminTeleportPlayerById`, JSON.stringify({
                playerId: playerId
            }));

            // Clear input
            $('#player-id-input').val('');
        });

        // Add event listener for Enter key on player ID input
        $('#player-id-input').keypress(function(e) {
            if (e.which === 13) { // Enter key
                $('#teleport-by-id-button').click();
            }
        });

        // Add event listener for close button
        $('#admin-close-button').click(function() {
            $.post(`https://${resourceName}/adminClose`, JSON.stringify({}));
            $('#admin-container').hide();
            $('body').fadeOut(500);
        });
    }

    // Populate reports list
    function populateReportsList(reports) {
        const reportsList = $('#reports-list');
        reportsList.empty();

        if (!reports || reports.length === 0) {
            reportsList.append('<div class="no-reports">No reports found</div>');
            return;
        }

        reports.forEach(report => {
            // Create status badge
            let statusBadge = '';
            if (report.status === 'pending') {
                statusBadge = '<span class="status-badge pending">Pending</span>';
            } else if (report.status === 'resolved') {
                statusBadge = '<span class="status-badge resolved">Resolved</span>';
            } else if (report.status === 'invalid') {
                statusBadge = '<span class="status-badge invalid">Invalid</span>';
            }

            const reportItem = $(`
                <div class="report-item" data-id="${report.id}">
                    <div class="report-header">
                        <div class="report-title">Report #${report.id} - ${report.playerName} (ID: ${report.playerId})</div>
                        ${statusBadge}
                    </div>
                    <div class="report-details">
                        <div class="report-info">Location: ${report.coordsString}</div>
                        <div class="report-info">Time: ${report.timeString}</div>
                    </div>
                    <div class="report-actions">
                        <button class="teleport-player-btn" data-id="${report.playerId}">
                            <span class="btn-text">Teleport Player</span>
                            <span class="btn-glow"></span>
                        </button>
                        <button class="teleport-to-btn" data-id="${report.playerId}">
                            <span class="btn-text">Teleport To</span>
                            <span class="btn-glow"></span>
                        </button>
                        <button class="resolve-btn" data-id="${report.id}">
                            <span class="btn-text">Mark Resolved</span>
                            <span class="btn-glow"></span>
                        </button>
                        <button class="invalid-btn" data-id="${report.id}">
                            <span class="btn-text">Mark Invalid</span>
                            <span class="btn-glow"></span>
                        </button>
                    </div>
                </div>
            `);

            reportsList.append(reportItem);
        });

        // Add event listeners for report actions
        $('.teleport-player-btn').click(function() {
            const playerId = $(this).data('id');
            $.post(`https://${resourceName}/adminTeleportPlayer`, JSON.stringify({
                playerId: playerId
            }));
        });

        $('.teleport-to-btn').click(function() {
            const playerId = $(this).data('id');
            $.post(`https://${resourceName}/adminTeleportToPlayer`, JSON.stringify({
                playerId: playerId
            }));
        });

        $('.resolve-btn').click(function() {
            const reportId = $(this).data('id');
            $.post(`https://${resourceName}/adminResolveReport`, JSON.stringify({
                reportId: reportId,
                status: 'resolved'
            }));
        });

        $('.invalid-btn').click(function() {
            const reportId = $(this).data('id');
            $.post(`https://${resourceName}/adminResolveReport`, JSON.stringify({
                reportId: reportId,
                status: 'invalid'
            }));
        });
    }

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

        // Add click event to player items
        $('.player-item').click(function() {
            $('.player-item').removeClass('selected');
            $(this).addClass('selected');
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
});
