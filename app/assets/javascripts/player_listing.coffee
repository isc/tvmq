Vue.component 'player-listing',
  props: ['players', 'inProgress', 'playerId']
  template: '<div class="list-group">
    <div
      v-for="player in players"
      class="list-group-item d-flex justify-content-between align-items-center"
    >
      {{player.name}}
      <span class="badge badge-primary badge-pill" v-if="!inProgress && player.id == playerId">Me</span>
      <span class="badge badge-primary badge-pill" v-if="inProgress">{{player.score}}</span>
    </div>
  </div>'
