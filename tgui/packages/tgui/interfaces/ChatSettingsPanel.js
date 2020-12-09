import { useBackend } from '../backend';
import { Section, Button } from '../components';
import { Window } from '../layouts';

export const ChatSettingsPanel = (props, context) => {
  const { act, data } = useBackend(context);
  const ignoresPreSort = data.ignore || [];
  const ignores = ignoresPreSort.sort((a, b) => {
    const descA = a.desc.toLowerCase();
    const descB = b.desc.toLowerCase();
    if (descA < descB) {
      return -1;
    }
    if (descA > descB) {
      return 1;
    }
    return 0;
  });
  return (
    <Window
      title="Настройка чата"
      width={270}
      height={560}
      resizable>
      <Window.Content scrollable>
        <Section title="Настройка чата">
          {ignores.map(ignore => (
            <Button
              fluid
              key={ignore.key}
              icon={ignore.enabled ? 'times' : 'check'}
              content={ignore.desc}
              color={ignore.enabled ? 'bad' : 'good'}
              onClick={() => act('toggle_ignore', { key: ignore.key })} />
          ))}
        </Section>
      </Window.Content>
    </Window>
  );
};
