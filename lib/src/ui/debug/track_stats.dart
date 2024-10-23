import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../context/room.dart';
import '../../context/track.dart';

class TrackStatsWidget extends StatelessWidget {
  const TrackStatsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var trackCtx = Provider.of<TrackContext?>(context);
    var roomCtx = Provider.of<RoomContext?>(context);

    if (trackCtx == null || roomCtx?.focusedTrackSid != trackCtx?.sid) {
      return const SizedBox();
    }

    return Consumer<TrackContext>(
      builder: (context, trackCtx, child) =>
          Selector<TrackContext, Map<String, String>>(
        selector: (context, trackCtx) => trackCtx.stats,
        builder:
            (BuildContext context, Map<String, String> stats, Widget? child) {
          return Center(
            child: Stack(
              children: [
                trackCtx.showStatistics && stats.isNotEmpty
                    ? Container(
                        color: Colors.black.withOpacity(0.3),
                        padding: const EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 8,
                        ),
                        child: Column(children: [
                          Text('${trackCtx.isVideo ? 'video' : 'audio'} stats',
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16)),
                          ...stats.entries
                              .map((e) => Text('${e.key}: ${e.value}')),
                        ]),
                      )
                    : const SizedBox(),
                Container(
                  padding: const EdgeInsets.all(2),
                  child: IconButton(
                    icon: Icon(
                        trackCtx.showStatistics ? Icons.close : Icons.info),
                    color: Colors.white70,
                    onPressed: () {
                      // show stats
                      trackCtx.showStatistics = !trackCtx.showStatistics;
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}