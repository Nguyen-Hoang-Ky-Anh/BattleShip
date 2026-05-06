let isPlaying = false;

window.onload = function () {
    window.music = document.getElementById("bgMusic");
};

function toggleMusic() {
    if (isPlaying) {
        music.pause();
    } else {
        music.play();
    }
    isPlaying = !isPlaying;
}

function goHowToPlay() {
    alert("Show instructions here!");
}

function goHistory() {
    alert("Match history here!");
}

/* HAMBURGER MENU */
function toggleMenu() {
    let menu = document.getElementById("dropdown");
    menu.style.display = (menu.style.display === "block") ? "none" : "block";
}