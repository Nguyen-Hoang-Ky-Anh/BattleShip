// =========================
// PVE SHIP PLACEMENT
// =========================

async function confirmPlacement() {

    const allPlaced =
        SHIP_CATALOG.every(
            ship => ship.placed
        );

    if (!allPlaced) {

        setStatus(
            "⚠ Place all ships first!"
        );

        return;
    }

    isLocked = true;

    const shipData = placedShips.map(ship => ({

        name: ship.name,

        size: ship.size,

        direction: ship.direction,

        cells: ship.cells
    }));

    try {

        setStatus(
            "🚀 Starting battle..."
        );

        const response = await fetch(

            contextPath + "/ship-placement-pve",

            {
                method: "POST",

                headers: {
                    "Content-Type":
                        "application/json"
                },

                body: JSON.stringify({

                    action: "start-battle",

                    ships: shipData
                })
            }
        );

        if (!response.ok) {

            throw new Error(
                "Failed to create game"
            );
        }

        const data =
            await response.json();

        if (data.success) {

            /*
             * Save my board locally
             * for battle rendering
             */
            localStorage.setItem(

                "playerBoard",

                JSON.stringify(shipData)
            );

            /*
             * Redirect battle
             */
            window.location.href =

                contextPath
                + "/battle-pve?gameId="
                + data.gameId;
        }
        else {

            setStatus(
                "❌ Failed to start game"
            );
        }

    } catch (e) {

        console.error(e);

        setStatus(
            "❌ Server error"
        );
    }
}

// =========================
// HELPERS
// =========================

function setStatus(message) {

    const el =
        document.getElementById(
            "placementStatus"
        );

    if(el) {

        el.textContent = message;
    }
}
