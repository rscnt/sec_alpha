function createChart() {
    $("#candidatoGrafica").kendoChart({
        title: {
            position: "top",
            text: "Resultados Candidatos"
        },
        legend: {
            visible: true,
            position: "bottom"
        },
        chartArea: {
            background: ""
        },
        seriesDefaults: {
            labels: {
                visible: false,
                background: "transparent",
                template: "#= category #: #= value#%"
            }
        },
        dataSource: {
            data: data
        },
        series: [{
                type: "pie",
                startAngle: 150,
                field: "puntaje",
                categoryField: "nombre"
            }],
        tooltip: {
            visible: true,
            template: "#= category # - #= kendo.format('{0:P}', percentage) #"
        }
    });
}

$(document).ready(function() {
    setTimeout(function() {
        // Initialize the chart with a delay to make sure
        // the initial animation is visible
        createChart();

        $("#candidatoPie").bind("kendo:skinChange", function(e) {
            createChart();
        });

        // this is about 

        for (var especialidad in dataVotacion) {

            buildProgress(
                    dataVotacion[especialidad]
                    );
        }

        // this is about 

    }, 400);

});

/*
 * Building progress bars, there in the html should be a DOM width id = progress-cont
 * @param String idSufix 
 * @param Integer total
 * @param Integer muestra
 * @return void
 */

function buildProgress(settings) {

    if (typeof settings === "object") {

        var id = settings.id ||
                Math.round((Math.random() * 50) + 1), //very stupid.
                especialidad = settings.nombre || 'fantasmas',
                alumnos = settings.alumnos || 0,
                votaciones_realizadas = settings.votaciones_realizadas || 0,
                value = getPercent(alumnos, votaciones_realizadas);


        // progressbar building based on jquery-ui documentation
        // vanilla is faster.
        var container = document.createElement("div"),
                progressbar = document.createElement("div"),
                progressbarContainer = document.createElement("div"),
                progressbarLabel = document.createElement("div"),
                progressEspecialidad = document.createElement("div");

        container.setAttribute("id", "prog-" + id);

        container.setAttribute("class", "progressbar-container");

        progressEspecialidad.setAttribute("class", "pEspecialidad fourcol");

//        progressEspecialidad.setAttribute("style", "position: relative");

        // this is ugly and stupid as fuck.
        progressEspecialidad.innerHTML = "<span style= \""
                + "line-height: 30px;"
                + "\">"
                + especialidad
                + "</span>";

        progressbarContainer.setAttribute("class", "sixcol last");

        progressbarLabel.setAttribute("class", "twocol");

        progressbarLabel.innerHTML = value;
        
        progressbarLabel.setAttribute("style", "line-height: 30px;");

        $progressbar = $(progressbar);
        $container = $(container);

        $progressbar.progressbar({
            value: value
        });

        progressbarValue = $progressbar.find(".ui-progressbar-value");

        progressbarValue.css({
            "background": '#'
                    + Math.floor(Math.random() * 16777215).toString(16)
        });

        $container.append(
                $(progressEspecialidad)
                );

        $container.append(
                $(progressbarLabel)
                );
                    
        $container.append(
                $progressbar
                );

        $("#progress-cont").append(
                $container
                );


        return true;

    } else {
        return false;
    }
}

// utils.js ?
function getPercent(t, p) {
    if (p === 0) {
        return 0;
    }
    else {
        return ((p / t) * 100);
    }
}