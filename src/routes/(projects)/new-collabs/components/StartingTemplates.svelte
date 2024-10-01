<script lang="ts">
  import startingTemplates from "../data/startingTemplates.json";
</script>

<div class="flex flex-col">
  <h2>Starting Template</h2>
  <p>
    The initial population of ccot's were generated based on well known theories
    of creativity
  </p>
  <div class="w-full overflow-x-auto py-4">
    <div class="flex space-x-4 px-4">
      {#each startingTemplates as template}
        <div
          class="flex-shrink-0 w-80 bg-white rounded-none shadow-md overflow-hidden border border-gray-200"
        >
          <div class="py-3 px-4 border-b">
            <h3 class="text-lg font-semibold">{template.name}</h3>
          </div>
          <ul class="divide-y divide-gray-200">
            {#each template.steps as step, index}
              <li
                class="px-4 py-3 text-sm text-gray-700 hover:bg-gray-50 text-left"
              >
                <span class="font-medium text-gray-900 mr-2">{index + 1}.</span>
                {step}
              </li>
            {/each}
          </ul>
        </div>
      {/each}
    </div>
  </div>
</div>
