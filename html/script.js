$(function () {
  const RES_NAME = (typeof GetParentResourceName === 'function') ? GetParentResourceName() : 'qt_garage';

  $("#searchvehicle").on("keyup", function () {
    const value = $(this).val().toLowerCase();
    $(".selectedvehicle .vehicle-card").each(function () {
      $(this).toggle($(this).text().toLowerCase().indexOf(value) > -1);
    });
  });

  let lastplate, laststored, lastgaraj;

  function resetLeftPanel() {
    $('.platevehicle').text('--');
    $('.damagevehicle').text('--%');
    $('.bodyhealth').text('--%');
    $('.stored').text('--');
    $('.fuellevel').text('0 LITRES');
    $('.fuel-fill').css('width', '0%');
    $('.car-name-display').text('');
  }

  function notify(text, type = "info") {
    $(".notify").removeClass("show error success");
    if (type === "error") $(".notify").addClass("error");
    else if (type === "success") $(".notify").addClass("success");
    $(".notify").text(text).addClass("show");
    setTimeout(() => $(".notify").removeClass("show"), 3000);
  }

  window.addEventListener('message', function (event) {
    const data = event.data;

    if (data.action === 'reset') {
      $(".selectedvehicle").empty();
      resetLeftPanel();
      return;
    }

    if (data.action === 'open') {
      $('.container').css('display', 'flex');

      const vehicleCard = document.createElement('div');
      vehicleCard.className = 'vehicle-card';
      vehicleCard.setAttribute('data-plate', data.plate);
      vehicleCard.setAttribute('data-impound', data.impound ? 'true' : 'false');
      vehicleCard.setAttribute('data-damage', data.damage);
      
      const storedValue = data.stored === 1 || data.stored === "1" ? "1" : "0";
      vehicleCard.setAttribute('data-stored', storedValue);
      
      vehicleCard.setAttribute('data-body', data.body);
      vehicleCard.setAttribute('data-fuellevel', data.fuellevel);
      vehicleCard.setAttribute('data-hash', data.carhash);
      vehicleCard.setAttribute('data-garajtype', data.garaj);

      const imageContainer = document.createElement('div');
      imageContainer.className = 'vehicle-image';

      const img = document.createElement('img');
      const path = `nui://${RES_NAME}/html/image/${data.modelImageName}.png`;
      img.src = path;
      img.alt = data.name || data.modelImageName;

      img.onerror = function() {
        this.src = `nui://${RES_NAME}/html/image/default.png`;
        notify(`Image manquante: ${data.modelImageName}.png`, "error");
      };

      imageContainer.appendChild(img);
      vehicleCard.appendChild(imageContainer);

      const infoContainer = document.createElement('div');
      infoContainer.className = 'vehicle-info';

      const vehicleName = document.createElement('h3');
      vehicleName.textContent = data.name || data.modelImageName;

      infoContainer.appendChild(vehicleName);
      vehicleCard.appendChild(infoContainer);

      document.querySelector('.selectedvehicle').appendChild(vehicleCard);
    }

    if (data.action === 'notify') {
      notify(data.message, data.type);
    }
  });

  $(document).on("click", ".vehicle-card", function () {
    $('.vehicle-card').removeClass('selected');
    $(this).addClass('selected');

    const garaj = $(this).attr("data-garajtype");
    lastgaraj = garaj;
    const plate = $(this).attr("data-plate");
    const damage = parseFloat($(this).attr("data-damage") || '0');
    const body = parseFloat($(this).attr("data-body") || '0');
    const stored = $(this).attr("data-stored");
    const impound = $(this).attr("data-impound") === 'true';
    const fuel = parseFloat($(this).attr("data-fuellevel") || '0');
    
    lastplate = plate;
    laststored = stored;

    $('.platevehicle').text(plate);
    $('.damagevehicle').text(`${Math.max(0, Math.min(100, damage|0))}%`);
    $('.bodyhealth').text(`${Math.max(0, Math.min(100, body|0))}%`);
    $('.fuellevel').text(`${Math.max(0, Math.min(100, fuel|0))} LITRES`);
    $('.fuel-fill').css('width', `${Math.max(0, Math.min(100, fuel))}%`);

    const vehicleName = $(this).find('h3').text();
    $('.car-name-display').text(vehicleName);

    if (garaj == '1') {
      $(".stored").text(stored === "1" ? 'Garé' : 'Dehors');
    } else {
      $(".stored").text(impound ? 'Dehors' : 'Garé');
      laststored = impound ? '0' : '1';
    }
  });

  $(document).on("click", "#spawncar", function () {
    if (!lastplate) return notify("Veuillez sélectionner un véhicule d'abord", "error");
    
    if (laststored !== "1") {
      notify("Le véhicule n'est pas dans le garage !", "error");
      return;
    }

    $.post(`https://${RES_NAME}/spawnvehicle`, JSON.stringify({ plate: lastplate }));
    $('.container').hide();
    $.post(`https://${RES_NAME}/closepage`, JSON.stringify({}));
    lastplate = null;
    $(".selectedvehicle").empty();
    
    notify("Véhicule sorti avec succès", "success");
  });

  $(document).on("click", ".closeimg", function () {
    $('.container').hide();
    $.post(`https://${RES_NAME}/closepage`, JSON.stringify({}));
    lastplate = null;
    $(".selectedvehicle").empty();
  });

  $(document).keydown(function (e) {
    if (e.keyCode == 27) {
      $('.container').hide();
      $.post(`https://${RES_NAME}/closepage`, JSON.stringify({}));
      lastplate = null;
      $(".selectedvehicle").empty();
    }
  });
});